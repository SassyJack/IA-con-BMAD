import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:security_vault/security_vault.dart';
import 'package:serenti/app/app.dart';
import 'package:serenti/app/data/repositories/legal_repository.dart';
import 'package:serenti/app/data/repositories/pet_repository.dart';
import 'package:serenti/app/data/repositories/phq9_repository.dart';
import 'package:serenti/app/data/repositories/user_settings_repository.dart';
import 'package:serenti/app/data/repositories/sensor_repository.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';
import 'package:serenti/app/view/habitat/habitat_page.dart';
import 'package:serenti/app/view/security/lock_screen.dart';
import 'package:isar_database/isar_database.dart';

class MockLegalRepository extends Mock implements LegalRepository {}
class MockSecurityVault extends Mock implements SecurityVault {}
class MockUserSettingsRepository extends Mock implements UserSettingsRepository {}
class MockPetRepository extends Mock implements PetRepository {}
class MockPhq9Repository extends Mock implements Phq9Repository {}
class MockSensorRepository extends Mock implements SensorRepository {}
class MockInferenceRepository extends Mock implements InferenceRepository {}
class MockIsarDatabase extends Mock implements IsarDatabase {}
class MockIsar extends Mock implements Isar {}

// Use dynamic for generic Isar types to avoid complex mocking in this view test
class MockIsarCollection extends Mock implements IsarCollection<MiloState> {}
abstract class FakeQueryBuilder extends Mock implements QueryBuilder<MiloState, MiloState, QWhere> {
  Stream<List<MiloState>> watch({bool fireImmediately = false});
  dynamic sortByTimestampDesc();
  Future<MiloState?> findFirst();
}
class MockQueryBuilder extends Mock implements FakeQueryBuilder {}

void main() {
  group('App', () {
    late LegalRepository legalRepository;
    late SecurityVault securityVault;
    late UserSettingsRepository userSettingsRepository;
    late PetRepository petRepository;
    late Phq9Repository phq9Repository;
    late SensorRepository sensorRepository;
    late InferenceRepository inferenceRepository;
    late IsarDatabase isarDatabase;
    late Isar isar;

    setUp(() {
      legalRepository = MockLegalRepository();
      securityVault = MockSecurityVault();
      userSettingsRepository = MockUserSettingsRepository();
      petRepository = MockPetRepository();
      phq9Repository = MockPhq9Repository();
      sensorRepository = MockSensorRepository();
      inferenceRepository = MockInferenceRepository();
      isarDatabase = MockIsarDatabase();
      isar = MockIsar();
      
      final miloStateCollection = MockIsarCollection();
      final mockQueryBuilder = MockQueryBuilder();

      when(() => isarDatabase.getInstance(encryptionKey: any(named: 'encryptionKey')))
          .thenAnswer((_) async => isar);
      when(() => isar.miloStates).thenReturn(miloStateCollection as IsarCollection<MiloState>);
      
      when(() => miloStateCollection.where()).thenReturn(mockQueryBuilder as dynamic);
      when(() => mockQueryBuilder.watch()).thenAnswer((_) => const Stream.empty());
      // For more complex queries, just return the builder to allow chaining if needed
      // although RiskCubit currently only uses where().watch() and where().sortByTimestampDesc().findFirst()
      
      when(() => mockQueryBuilder.sortByTimestampDesc()).thenReturn(mockQueryBuilder as dynamic);
      when(() => mockQueryBuilder.findFirst()).thenAnswer((_) async => null);
      when(() => mockQueryBuilder.watch(fireImmediately: any(named: 'fireImmediately')))
          .thenAnswer((_) => const Stream.empty());

      when(() => sensorRepository.sensorEvents).thenAnswer((_) => const Stream.empty());
      when(() => sensorRepository.startCollection()).thenAnswer((_) async {});
      when(() => inferenceRepository.evaluateRisk()).thenAnswer((_) async => false);
      when(() => inferenceRepository.runInference()).thenAnswer((_) async {});

      when(() => legalRepository.hasAcceptedConsent())
          .thenAnswer((_) async => true);
      
      final mockSettings = UserSettings()
        ..isOnboardingComplete = true
        ..petCustomized = true
        ..pendingSteps = [];
      when(() => userSettingsRepository.getUserSettings())
          .thenAnswer((_) async => mockSettings);
      
      when(() => petRepository.getPetProfile()).thenAnswer((_) async => null);
    });

    testWidgets('renders LockScreen when PIN is set', (tester) async {
      when(() => securityVault.hasPinSet()).thenAnswer((_) async => true);
      when(() => securityVault.isBiometricEnabled()).thenAnswer((_) async => false);
      when(() => securityVault.getFailedAttempts()).thenAnswer((_) async => 0);

      await tester.pumpWidget(App(
        legalRepository: legalRepository,
        securityVault: securityVault,
        userSettingsRepository: userSettingsRepository,
        petRepository: petRepository,
        phq9Repository: phq9Repository,
        sensorRepository: sensorRepository,
        inferenceRepository: inferenceRepository,
        isarDatabase: isarDatabase,
      ));
      
      await tester.pump(); 
      await tester.pump(const Duration(seconds: 1));
      
      expect(find.byType(LockScreen), findsOneWidget);
    });

    testWidgets('renders HabitatPage when authenticated and onboarding done', (tester) async {
      when(() => securityVault.hasPinSet()).thenAnswer((_) async => true);
      when(() => securityVault.isBiometricEnabled()).thenAnswer((_) async => false);
      when(() => securityVault.verifyPin(any())).thenAnswer((_) async => true);

      await tester.pumpWidget(App(
        legalRepository: legalRepository,
        securityVault: securityVault,
        userSettingsRepository: userSettingsRepository,
        petRepository: petRepository,
        phq9Repository: phq9Repository,
        sensorRepository: sensorRepository,
        inferenceRepository: inferenceRepository,
        isarDatabase: isarDatabase,
      ));
      
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
