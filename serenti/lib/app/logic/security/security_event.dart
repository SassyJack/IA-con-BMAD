part of 'security_bloc.dart';

sealed class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object> get props => [];
}

class SecurityCheckStatus extends SecurityEvent {}

class SecuritySetPin extends SecurityEvent {
  const SecuritySetPin(this.pin);
  final String pin;

  @override
  List<Object> get props => [pin];
}

class SecurityAuthenticateWithPin extends SecurityEvent {
  const SecurityAuthenticateWithPin(this.pin);
  final String pin;

  @override
  List<Object> get props => [pin];
}

class SecurityAuthenticateWithBiometrics extends SecurityEvent {}

class SecurityLockSession extends SecurityEvent {}

class SecurityToggleBiometrics extends SecurityEvent {
  const SecurityToggleBiometrics({required this.enabled});
  final bool enabled;

  @override
  List<Object> get props => [enabled];
}
