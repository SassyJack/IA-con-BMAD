part of 'onboarding_bloc.dart';

enum OnboardingStatus { initial, loading, inProgress, complete, error }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.pendingSteps = const [],
    this.isCalibrating = false,
  });

  final OnboardingStatus status;
  final List<String> pendingSteps;
  final bool isCalibrating;

  OnboardingState copyWith({
    OnboardingStatus? status,
    List<String>? pendingSteps,
    bool? isCalibrating,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      pendingSteps: pendingSteps ?? this.pendingSteps,
      isCalibrating: isCalibrating ?? this.isCalibrating,
    );
  }

  @override
  List<Object> get props => [status, pendingSteps, isCalibrating];
}
