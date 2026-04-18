import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serenti/app/data/repositories/user_settings_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required UserSettingsRepository userSettingsRepository,
  })  : _userSettingsRepository = userSettingsRepository,
        super(const OnboardingState()) {
    on<OnboardingCheckStatus>(_onCheckStatus);
    on<OnboardingSkipStep>(_onSkipStep);
    on<OnboardingCompleteStep>(_onCompleteStep);
  }

  final UserSettingsRepository _userSettingsRepository;

  Future<void> _onCheckStatus(
    OnboardingCheckStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    try {
      final settings = await _userSettingsRepository.getUserSettings();
      
      bool isCalibrating = false;
      if (settings.calibrationStartDate != null) {
        final days = DateTime.now().difference(settings.calibrationStartDate!).inDays;
        isCalibrating = days < 7;
      }

      emit(state.copyWith(
        status: settings.isOnboardingComplete ? OnboardingStatus.complete : OnboardingStatus.inProgress,
        pendingSteps: settings.pendingSteps,
        isCalibrating: isCalibrating,
      ));
    } catch (_) {
      emit(state.copyWith(status: OnboardingStatus.error));
    }
  }

  Future<void> _onSkipStep(
    OnboardingSkipStep event,
    Emitter<OnboardingState> emit,
  ) async {
    // For now, skipping just transitions the UI state. 
    // In a real app, it would also move to the next screen.
    // If all optional steps are skipped/done, it marks onboarding as "Complete enough"
    emit(state.copyWith(status: OnboardingStatus.complete));
  }

  Future<void> _onCompleteStep(
    OnboardingCompleteStep event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final settings = await _userSettingsRepository.getUserSettings();
      final updatedSteps = List<String>.from(settings.pendingSteps)..remove(event.step);
      
      final isComplete = updatedSteps.isEmpty;
      
      await _userSettingsRepository.updateOnboardingStatus(
        isComplete: isComplete,
        pendingSteps: updatedSteps,
      );

      emit(state.copyWith(
        status: isComplete ? OnboardingStatus.complete : OnboardingStatus.inProgress,
        pendingSteps: updatedSteps,
      ));
    } catch (_) {
      emit(state.copyWith(status: OnboardingStatus.error));
    }
  }
}
