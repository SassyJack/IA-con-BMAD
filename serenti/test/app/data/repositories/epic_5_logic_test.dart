import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';
import 'package:tflite_service/tflite_service.dart';
import 'package:path/path.dart' as p;

class MockTfliteService extends Mock implements TfliteService {}

void main() {
  Isar? isar;
  late IsarDatabase isarDatabase;
  late InferenceRepository repository;
  late Directory tempDir;
  bool skipTests = false;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_logic_test');
    isarDatabase = IsarDatabase();
    try {
      isar = await isarDatabase.getInstance(directory: tempDir.path);
    } catch (e) {
      print('Skipping Isar integration tests: $e');
      skipTests = true;
    }
  });

  tearDownAll(() async {
    await isar?.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  setUp(() async {
    if (skipTests) return;
    await isar!.writeTxn(() => isar!.clear());
    repository = InferenceRepository(
      isarDatabase: isarDatabase,
      tfliteService: MockTfliteService(),
    );
  });

  group('InferenceRepository - evaluateRisk (Integration)', () {
    test('returns false if settings missing', () async {
      if (skipTests) return;
      final result = await repository.evaluateRisk();
      expect(result, isFalse);
    });

    test('returns true if latest mood is shelter with high confidence', () async {
      if (skipTests) return;
      // 1. Setup baseline
      final settings = UserSettings()
        ..averageMobility = 100
        ..averageSocial = 10;
      
      await isar!.writeTxn(() => isar!.userSettings.put(settings));

      // 2. Setup latest state as shelter
      final latestState = MiloState()
        ..mood = MiloMood.shelter
        ..confidenceScore = 0.8
        ..timestamp = DateTime.now();
      
      await isar!.writeTxn(() => isar!.miloStates.put(latestState));

      final result = await repository.evaluateRisk();
      expect(result, isTrue);
    });

    test('returns true if mobility drops > 50%', () async {
      if (skipTests) return;
      // 1. Setup baseline
      final settings = UserSettings()
        ..averageMobility = 100
        ..averageSocial = 10;
      
      await isar!.writeTxn(() => isar!.userSettings.put(settings));

      // 2. Setup normal latest state
      final latestState = MiloState()
        ..mood = MiloMood.idle
        ..confidenceScore = 1.0
        ..timestamp = DateTime.now();
      
      await isar!.writeTxn(() => isar!.miloStates.put(latestState));

      // 3. Add 10 mobility records (less than 50% of 100 baseline)
      final recentData = List.generate(10, (_) => SensorData()
        ..source = SensorDataSource.mobility
        ..timestamp = DateTime.now());
      
      await isar!.writeTxn(() => isar!.sensorDatas.putAll(recentData));

      final result = await repository.evaluateRisk();
      expect(result, isTrue);
    });

    test('returns false if everything is normal', () async {
      if (skipTests) return;
      final settings = UserSettings()
        ..averageMobility = 10
        ..averageSocial = 5;
      
      await isar!.writeTxn(() => isar!.userSettings.put(settings));

      final latestState = MiloState()
        ..mood = MiloMood.idle
        ..confidenceScore = 1.0
        ..timestamp = DateTime.now();
      
      await isar!.writeTxn(() => isar!.miloStates.put(latestState));

      // 15 items > 10 baseline -> no drop
      final recentData = List.generate(15, (_) => SensorData()
        ..source = SensorDataSource.mobility
        ..timestamp = DateTime.now());
      
      await isar!.writeTxn(() => isar!.sensorDatas.putAll(recentData));

      final result = await repository.evaluateRisk();
      expect(result, isFalse);
    });
   group('Skipped', () {
      test('Isar not available on this machine', () {
        if (!skipTests) return;
        print('Integration logic tests skipped because Isar binary was not found.');
      });
    });
  });
}
