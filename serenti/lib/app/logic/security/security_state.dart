part of 'security_bloc.dart';

enum SecurityStatus { initial, loading, setupRequired, unauthenticated, authenticated, lockedOut, error }

class SecurityState extends Equatable {
  const SecurityState({
    this.status = SecurityStatus.initial,
    this.isBiometricEnabled = false,
    this.errorMessage = '',
    this.failedAttempts = 0,
  });

  final SecurityStatus status;
  final bool isBiometricEnabled;
  final String errorMessage;
  final int failedAttempts;

  SecurityState copyWith({
    SecurityStatus? status,
    bool? isBiometricEnabled,
    String? errorMessage,
    int? failedAttempts,
  }) {
    return SecurityState(
      status: status ?? this.status,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
      failedAttempts: failedAttempts ?? this.failedAttempts,
    );
  }

  @override
  List<Object> get props => [status, isBiometricEnabled, errorMessage, failedAttempts];
}
