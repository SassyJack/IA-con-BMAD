import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_database/isar_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/data/repositories/user_settings_repository.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';

class MockUserSettingsRepository extends Mock implements UserSettingsRepository {}

void main() {
  group('OnboardingBloc', () {
    late UserSettingsRepository userSettingsRepository;

    setUp(() {
      userSettingsRepository = MockUserSettingsRepository();
    });

    OnboardingBloc buildBloc() {
      return OnboardingBloc(userSettingsRepository: userSettingsRepository);
    }

    test('initial state is correct', () {
      expect(buildBloc().state, const OnboardingState());
    });

    group('OnboardingCheckStatus', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'emits [loading, complete] with isCalibrating=true when 2 days since start',
        setUp: () {
          final settings = UserSettings()
            ..isOnboardingComplete = true
            ..calibrationStartDate = DateTime.now().subtract(const Duration(days: 2))
            ..pendingSteps = [];
          when(() => userSettingsRepository.getUserSettings()).thenAnswer((_) async => settings);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const OnboardingCheckStatus()),
        expect: () => [
          const OnboardingState(status: OnboardingStatus.loading),
          const OnboardingState(
            status: OnboardingStatus.complete,
            isCalibrating: true,
            pendingSteps: [],
          ),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits [loading, complete] with isCalibrating=false when 8 days since start',
        setUp: () {
          final settings = UserSettings()
            ..isOnboardingComplete = true
            ..calibrationStartDate = DateTime.now().subtract(const Duration(days: 8))
            ..pendingSteps = [];
          when(() => userSettingsRepository.getUserSettings()).thenAnswer((_) async => settings);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const OnboardingCheckStatus()),
        expect: () => [
          const OnboardingState(status: OnboardingStatus.loading),
          const OnboardingState(
            status: OnboardingStatus.complete,
            isCalibrating: false,
            pendingSteps: [],
          ),
        ],
      );
    });
  });
}
