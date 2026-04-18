part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingCheckStatus extends OnboardingEvent {
  const OnboardingCheckStatus();
}

class OnboardingSkipStep extends OnboardingEvent {
  const OnboardingSkipStep(this.step);
  final String step;

  @override
  List<Object> get props => [step];
}

class OnboardingCompleteStep extends OnboardingEvent {
  const OnboardingCompleteStep(this.step);
  final String step;

  @override
  List<Object> get props => [step];
}
