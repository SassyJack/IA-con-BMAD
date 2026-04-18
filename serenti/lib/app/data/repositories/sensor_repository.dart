import 'dart:async';
import 'package:isar_database/isar_database.dart';
import 'package:sensor_kit/sensor_kit.dart';

/// {@template sensor_repository}
/// Repository that bridges [SensorKitService] and [IsarDatabase].
/// {@endtemplate}
class SensorRepository {
  /// {@macro sensor_repository}
  SensorRepository({
    required IsarDatabase isarDatabase,
    required SensorKitService sensorKitService,
  }) : _isarDatabase = isarDatabase,
       _sensorKitService = sensorKitService;

  final IsarDatabase _isarDatabase;
  final SensorKitService _sensorKitService;

  StreamSubscription<SensorEvent>? _subscription;

  /// Stream of sensor events.
  Stream<SensorEvent> get sensorEvents => _sensorKitService.sensorEvents;

  /// Starts sensor data collection and persistence.
  Future<void> startCollection() async {
    await _sensorKitService.start();
    final isar = await _isarDatabase.getInstance();

    _subscription = _sensorKitService.sensorEvents.listen((event) async {
      final sensorData = SensorData()
        ..timestamp = event.timestamp
        ..latitude = event.latitude
        ..longitude = event.longitude
        ..stepCount = event.stepCount
        ..socialActivityCount = event.socialActivityCount
        ..source = _mapTypeToSource(event.type);

      await isar.writeTxn<int>(() async {
        return await isar.sensorDatas.put(sensorData);
      });
    });
  }

  SensorDataSource _mapTypeToSource(SensorType type) {
    switch (type) {
      case SensorType.mobility:
        return SensorDataSource.mobility;
      case SensorType.activity:
        return SensorDataSource.activity;
      case SensorType.social:
        return SensorDataSource.social;
    }
  }

  /// Stops sensor data collection.
  Future<void> stopCollection() async {
    await _subscription?.cancel();
    await _sensorKitService.stop();
  }
}
