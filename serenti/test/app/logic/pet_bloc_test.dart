import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/data/repositories/pet_repository.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';

class MockPetRepository extends Mock implements PetRepository {}
class MockIsarDatabase extends Mock implements IsarDatabase {}
class MockIsar extends Mock implements Isar {}
class MockMiloStateCollection extends Mock implements IsarCollection<MiloState> {}

void main() {
  late PetRepository petRepository;
  late IsarDatabase isarDatabase;
  late Isar isar;

  setUpAll(() {
    registerFallbackValue(PetGender.neutral);
    registerFallbackValue(MiloMood.idle);
  });

  setUp(() {
    petRepository = MockPetRepository();
    isarDatabase = MockIsarDatabase();
    isar = MockIsar();
    when(() => isarDatabase.getInstance()).thenAnswer((_) async => isar);
  });

  group('PetBloc', () {
    test('initial state is PetState()', () {
      expect(PetBloc(petRepository: petRepository, isarDatabase: isarDatabase).state, const PetState());
    });

    blocTest<PetBloc, PetState>(
      'emits updated name when PetNameChanged is added',
      build: () => PetBloc(petRepository: petRepository, isarDatabase: isarDatabase),
      act: (bloc) => bloc.add(const PetNameChanged('Milo')),
      expect: () => [
        const PetState(name: 'Milo'),
      ],
    );

    blocTest<PetBloc, PetState>(
      'emits updated gender when PetGenderChanged is added',
      build: () => PetBloc(petRepository: petRepository, isarDatabase: isarDatabase),
      act: (bloc) => bloc.add(const PetGenderChanged(PetGender.female)),
      expect: () => [
        const PetState(gender: PetGender.female),
      ],
    );

    blocTest<PetBloc, PetState>(
      'emits updated mood when PetMoodUpdated is added',
      build: () => PetBloc(petRepository: petRepository, isarDatabase: isarDatabase),
      act: (bloc) => bloc.add(const PetMoodUpdated(MiloMood.joy)),
      expect: () => [
        const PetState(currentMood: MiloMood.joy),
      ],
    );

    blocTest<PetBloc, PetState>(
      'emits [loading, success] when PetProfileSubmitted is successful',
      setUp: () {
        when(() => petRepository.savePetProfile(
              name: any(named: 'name'),
              gender: any(named: 'gender'),
            )).thenAnswer((_) async {});
      },
      build: () => PetBloc(petRepository: petRepository, isarDatabase: isarDatabase),
      seed: () => const PetState(name: 'Milo', gender: PetGender.male),
      act: (bloc) => bloc.add(const PetProfileSubmitted()),
      expect: () => [
        const PetState(name: 'Milo', gender: PetGender.male, status: PetStatus.loading),
        const PetState(name: 'Milo', gender: PetGender.male, status: PetStatus.success),
      ],
      verify: (_) {
        verify(() => petRepository.savePetProfile(
              name: 'Milo',
              gender: PetGender.male,
            )).called(1);
      },
    );

    blocTest<PetBloc, PetState>(
      'emits [loading, failure] when PetProfileSubmitted fails',
      setUp: () {
        when(() => petRepository.savePetProfile(
              name: any(named: 'name'),
              gender: any(named: 'gender'),
            )).thenThrow(Exception('Failed to save'));
      },
      build: () => PetBloc(petRepository: petRepository, isarDatabase: isarDatabase),
      seed: () => const PetState(name: 'Milo', gender: PetGender.male),
      act: (bloc) => bloc.add(const PetProfileSubmitted()),
      expect: () => [
        const PetState(name: 'Milo', gender: PetGender.male, status: PetStatus.loading),
        const PetState(
          name: 'Milo',
          gender: PetGender.male,
          status: PetStatus.failure,
          errorMessage: 'Exception: Failed to save',
        ),
      ],
    );

    blocTest<PetBloc, PetState>(
      'emits updated state when LoadPetProfile is successful',
      setUp: () {
        final profile = PetProfile()
          ..name = 'Milo'
          ..gender = PetGender.male;
        when(() => petRepository.getPetProfile()).thenAnswer((_) async => profile);

        // We can safely ignore Isar mock here since PetBloc handles the failure gracefully
      },
      build: () => PetBloc(petRepository: petRepository, isarDatabase: isarDatabase),
      act: (bloc) => bloc.add(const LoadPetProfile()),
      expect: () => [
        const PetState(status: PetStatus.loading),
        const PetState(name: 'Milo', gender: PetGender.male, status: PetStatus.initial),
      ],
    );
  });
}

class MockMiloQueryBuilder extends Mock implements QueryBuilder<MiloState, MiloState, QAfterSortBy> {}
