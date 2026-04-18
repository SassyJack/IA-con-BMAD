import 'dart:async';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:tflite_service/tflite_service.dart';

/// {@template inference_repository}
/// Repository that coordinates sensor data aggregation and AI inference.
/// {@endtemplate}
class InferenceRepository {
  /// {@macro inference_repository}
  InferenceRepository({
    required IsarDatabase isarDatabase,
    required TfliteService tfliteService,
  }) : _isarDatabase = isarDatabase,
       _tfliteService = tfliteService;

  final IsarDatabase _isarDatabase;
  final TfliteService _tfliteService;
  Timer? _inferenceTimer;

  /// Starts the periodic inference cycle (every 6 hours).
  void startPeriodicInference() {
    _inferenceTimer?.cancel();
    // Run immediately on start
    unawaited(runInference());
    // Then every 6 hours
    _inferenceTimer = Timer.periodic(const Duration(hours: 6), (_) {
      unawaited(runInference());
    });
  }

  /// Manually triggers an inference cycle.
  Future<void> runInference() async {
    final isar = await _isarDatabase.getInstance();
    
    // Check calibration period
    final settings = await isar.userSettings.where().findFirst();
    final now = DateTime.now();
    
    bool isCalibrating = true;
    if (settings?.calibrationStartDate != null) {
      final daysSinceStart = now.difference(settings!.calibrationStartDate!).inDays;
      if (daysSinceStart >= 7) {
        isCalibrating = false;
        
        // Calculate baseline if not already done
        if (settings!.averageMobility == null) {
          await _calculateBaseline(isar, settings);
        }
      }
    } else {
      // If null, set it to now (this should have been set during onboarding)
      await isar.writeTxn(() async {
        if (settings != null) {
          settings.calibrationStartDate = now;
          await isar.userSettings.put(settings);
        }
      });
    }

    if (isCalibrating) {
      // Save a neutral state during calibration
      final miloState = MiloState()
        ..timestamp = now
        ..mood = MiloMood.idle
        ..confidenceScore = 1.0;

      await isar.writeTxn<int>(() async {
        return await isar.miloStates.put(miloState);
      });
      return;
    }
    
    // 1. Aggregate data from last 6 hours
    final sixHoursAgo = now.subtract(const Duration(hours: 6));
    
    final recentData = await isar.sensorDatas
        .filter()
        .timestampGreaterThan(sixHoursAgo)
        .findAll();

    if (recentData.isEmpty) {
      // Not enough data to run a meaningful inference yet
      return;
    }

    // 2. Pre-process / Normalize data for the model
    final input = preprocess(recentData);

    // 3. Run Inference
    final result = await _tfliteService.predict(input);

    // 4. Persist result
    final miloState = MiloState()
      ..timestamp = now
      ..mood = _mapInferenceMoodToMiloMood(result.mood)
      ..confidenceScore = result.confidence;

    await isar.writeTxn<int>(() async {
      return await isar.miloStates.put(miloState);
    });
  }

  /// Evaluates if the user is in a high-risk state.
  /// 
  /// High risk is defined as:
  /// - Latest mood is 'shelter' with high confidence (>0.7).
  /// - A drop of more than 50% in mobility or social activity compared 
  ///   to the baseline.
  Future<bool> evaluateRisk() async {
    final isar = await _isarDatabase.getInstance();
    final settings = await isar.userSettings.where().findFirst();
    
    // Cannot evaluate risk without baseline
    if (settings == null || settings.averageMobility == null) return false;

    final latestState = await isar.miloStates.where()
        .sortByTimestampDesc()
        .findFirst();
    
    if (latestState == null) return false;

    // 1. MLP Inference Risk: Shelter mood with high confidence
    final isMlpRisk = latestState.mood == MiloMood.shelter && 
                     latestState.confidenceScore > 0.7;

    // 2. Data Drop Risk: >50% drop in last 24h vs baseline
    final oneDayAgo = DateTime.now().subtract(const Duration(hours: 24));
    final recentData = await isar.sensorDatas
        .filter()
        .timestampGreaterThan(oneDayAgo)
        .findAll();

    var recentMobility = 0;
    var recentSocial = 0;
    for (final item in recentData) {
      if (item.source == SensorDataSource.mobility) recentMobility++;
      if (item.source == SensorDataSource.social) {
        recentSocial += item.socialActivityCount ?? 0;
      }
    }

    // Compare with daily averages
    final isMobilityDrop = settings.averageMobility! > 0 && 
        (recentMobility / settings.averageMobility!) < 0.5;
    
    final isSocialDrop = settings.averageSocial! > 0 && 
        (recentSocial / settings.averageSocial!) < 0.5;

    return isMlpRisk || isMobilityDrop || isSocialDrop;
  }

  Future<void> _calculateBaseline(Isar isar, UserSettings settings) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final historicalData = await isar.sensorDatas
        .filter()
        .timestampGreaterThan(sevenDaysAgo)
        .findAll();

    if (historicalData.isEmpty) return;

    var mobilitySum = 0;
    var stepsSum = 0;
    var socialSum = 0;

    for (final item in historicalData) {
      if (item.source == SensorDataSource.mobility) mobilitySum++;
      if (item.source == SensorDataSource.activity) stepsSum += item.stepCount ?? 0;
      if (item.source == SensorDataSource.social) socialSum += item.socialActivityCount ?? 0;
    }

    // Averages per day (approximate)
    settings.averageMobility = mobilitySum / 7.0;
    settings.averageSteps = (stepsSum / 7.0).round();
    settings.averageSocial = (socialSum / 7.0).round();

    await isar.writeTxn(() async {
      await isar.userSettings.put(settings);
    });
  }

  List<double> preprocess(List<SensorData> data) {
    // This is a simplified placeholder for the StudentLife feature engineering.
    // In a real scenario, we would calculate means, standard deviations, etc.
    
    var mobilityCount = 0;
    var totalSteps = 0;
    var socialCount = 0;

    for (final item in data) {
      if (item.source == SensorDataSource.mobility) mobilityCount++;
      if (item.source == SensorDataSource.activity) totalSteps += item.stepCount ?? 0;
      if (item.source == SensorDataSource.social) socialCount += item.socialActivityCount ?? 0;
    }

    // Mock normalization (expecting specific input size for the model, e.g., 3 features)
    return [
      mobilityCount.toDouble() / 100.0,
      totalSteps.toDouble() / 10000.0,
      socialCount.toDouble() / 10.0,
      0.0, // Extra padding if model expects more inputs
    ];
  }

  MiloMood _mapInferenceMoodToMiloMood(MiloInferenceMood mood) {
    switch (mood) {
      case MiloInferenceMood.idle:
        return MiloMood.idle;
      case MiloInferenceMood.joy:
        return MiloMood.joy;
      case MiloInferenceMood.rest:
        return MiloMood.rest;
      case MiloInferenceMood.shelter:
        return MiloMood.shelter;
    }
  }

  /// Stops the periodic inference.
  void stop() {
    _inferenceTimer?.cancel();
  }
}
