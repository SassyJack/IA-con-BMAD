import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tflite_service/tflite_service.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';

class MockIsarDatabase extends Mock implements IsarDatabase {}
class MockIsar extends Mock implements Isar {}
class MockSensorDataCollection extends Mock implements IsarCollection<SensorData> {}
class MockMiloStateCollection extends Mock implements IsarCollection<MiloState> {}
class MockUserSettingsCollection extends Mock implements IsarCollection<UserSettings> {}
class MockTfliteService extends Mock implements TfliteService {}
class MockQuery extends Mock implements Query<SensorData> {}
class MockQueryBuilder extends Mock implements QueryBuilder<SensorData, SensorData, QAfterFilterCondition> {}

void main() {
  late IsarDatabase isarDatabase;
  late Isar isar;
  late MockSensorDataCollection sensorCollection;
  late MockMiloStateCollection miloCollection;
  late MockUserSettingsCollection settingsCollection;
  late TfliteService tfliteService;
  late InferenceRepository inferenceRepository;

  setUpAll(() {
    registerFallbackValue(MiloState());
    registerFallbackValue(UserSettings());
    registerFallbackValue(<double>[]);
  });

  setUp(() {
    isarDatabase = MockIsarDatabase();
    isar = MockIsar();
    sensorCollection = MockSensorDataCollection();
    miloCollection = MockMiloStateCollection();
    settingsCollection = MockUserSettingsCollection();
    tfliteService = MockTfliteService();
    
    when(() => isarDatabase.getInstance()).thenAnswer((_) async => isar);
    when(() => isar.sensorDatas).thenReturn(sensorCollection);
    when(() => isar.miloStates).thenReturn(miloCollection);
    when(() => isar.userSettings).thenReturn(settingsCollection);
    
    // Mock Transaction
    when(() => isar.writeTxn<int>(any())).thenAnswer((invocation) async {
      final callback = invocation.positionalArguments[0] as Future<int> Function();
      return callback();
    });
    when(() => isar.writeTxn<void>(any())).thenAnswer((invocation) async {
      final callback = invocation.positionalArguments[0] as Future<void> Function();
      return callback();
    });

    inferenceRepository = InferenceRepository(
      isarDatabase: isarDatabase,
      tfliteService: tfliteService,
    );
  });

  group('InferenceRepository', () {
    test('_preprocess aggregates and normalizes sensor data correctly', () {
      final mockData = [
        SensorData()..source = SensorDataSource.mobility..timestamp = DateTime.now(),
        SensorData()..source = SensorDataSource.activity..stepCount = 1000..timestamp = DateTime.now(),
        SensorData()..source = SensorDataSource.social..socialActivityCount = 2..timestamp = DateTime.now(),
      ];

      final result = inferenceRepository.preprocess(mockData);

      expect(result.length, 4);
      expect(result[0], 1.0 / 100.0); // mobilityCount
      expect(result[1], 1000.0 / 10000.0); // totalSteps
      expect(result[2], 2.0 / 10.0); // socialCount
      expect(result[3], 0.0); // padding
    });
  });
}
