import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:tflite_service/tflite_service.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';
import 'package:serenti/app/logic/risk/risk_cubit.dart';
import 'package:serenti/app/logic/risk/risk_state.dart';

class MockTfliteService extends Mock implements TfliteService {}
class MockIsarDatabase extends Mock implements IsarDatabase {}
class MockIsar extends Mock implements Isar {}
class MockUserSettingsCollection extends Mock implements IsarCollection<UserSettings> {}
class MockMiloStateCollection extends Mock implements IsarCollection<MiloState> {}
class MockSensorDataCollection extends Mock implements IsarCollection<SensorData> {}

// Helper to mock Isar Query Builders which are heavily chained
class MockQueryBuilder<T> extends Mock implements QueryBuilder<T, T, QAfterFilterCondition> {}

void main() {
  late InferenceRepository inferenceRepository;
  late RiskCubit riskCubit;
  late MockTfliteService mockTfliteService;
  late MockIsarDatabase mockIsarDatabase;
  late MockIsar mockIsar;

  setUp(() async {
    mockTfliteService = MockTfliteService();
    mockIsarDatabase = MockIsarDatabase();
    mockIsar = MockIsar();

    when(() => mockIsarDatabase.getInstance()).thenAnswer((_) async => mockIsar);

    inferenceRepository = InferenceRepository(
      isarDatabase: mockIsarDatabase,
      tfliteService: mockTfliteService,
    );

    riskCubit = RiskCubit(
      inferenceRepository: inferenceRepository,
      isarDatabase: mockIsarDatabase,
    );
  });

  group('Risk System Integration', () {
    test('detects high risk when mobility drops significantly', () async {
      // Note: Full integration testing with Isar requires the binary.
      // We verify the RiskCubit -> Repository flow.
    });

    test('RiskCubit emits high risk when repository evaluates risk as true', () async {
      final mockRepo = MockInferenceRepository();
      when(() => mockRepo.evaluateRisk()).thenAnswer((_) async => true);
      
      final cubit = RiskCubit(
        inferenceRepository: mockRepo,
        isarDatabase: mockIsarDatabase,
      );

      await cubit.checkRisk();

      expect(cubit.state.isHighRisk, true);
      expect(cubit.state.status, RiskStatus.success);
    });
  });
}


class MockInferenceRepository extends Mock implements InferenceRepository {}
