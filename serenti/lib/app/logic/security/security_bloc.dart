import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:security_vault/security_vault.dart';

part 'security_event.dart';
part 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc({
    required SecurityVault securityVault,
  })  : _securityVault = securityVault,
        super(const SecurityState()) {
    on<SecurityCheckStatus>(_onCheckStatus);
    on<SecuritySetPin>(_onSetPin);
    on<SecurityAuthenticateWithPin>(_onAuthenticateWithPin);
    on<SecurityAuthenticateWithBiometrics>(_onAuthenticateWithBiometrics);
    on<SecurityLockSession>(_onLockSession);
    on<SecurityToggleBiometrics>(_onToggleBiometrics);
  }

  final SecurityVault _securityVault;

  void _onLockSession(
    SecurityLockSession event,
    Emitter<SecurityState> emit,
  ) {
    if (state.status == SecurityStatus.authenticated) {
      emit(state.copyWith(status: SecurityStatus.unauthenticated));
    }
  }

  Future<void> _onCheckStatus(
    SecurityCheckStatus event,
    Emitter<SecurityState> emit,
  ) async {
    emit(state.copyWith(status: SecurityStatus.loading));
    try {
      final hasPin = await _securityVault.hasPinSet();
      if (!hasPin) {
        emit(state.copyWith(status: SecurityStatus.setupRequired));
        return;
      }

      final bioEnabled = await _securityVault.isBiometricEnabled();
      emit(state.copyWith(
        status: SecurityStatus.unauthenticated,
        isBiometricEnabled: bioEnabled,
      ));
    } catch (_) {
      emit(state.copyWith(status: SecurityStatus.error));
    }
  }

  Future<void> _onSetPin(
    SecuritySetPin event,
    Emitter<SecurityState> emit,
  ) async {
    emit(state.copyWith(status: SecurityStatus.loading));
    try {
      await _securityVault.setPin(event.pin);
      emit(state.copyWith(status: SecurityStatus.authenticated));
    } catch (_) {
      emit(state.copyWith(
        status: SecurityStatus.error,
        errorMessage: 'Error al guardar el PIN',
      ));
    }
  }

  Future<void> _onAuthenticateWithPin(
    SecurityAuthenticateWithPin event,
    Emitter<SecurityState> emit,
  ) async {
    if (state.status == SecurityStatus.lockedOut) return;

    emit(state.copyWith(status: SecurityStatus.loading));
    try {
      final isValid = await _securityVault.verifyPin(event.pin);
      if (isValid) {
        emit(state.copyWith(
          status: SecurityStatus.authenticated,
          failedAttempts: 0,
        ));
      } else {
        final newFailedAttempts = state.failedAttempts + 1;
        if (newFailedAttempts >= 5) {
          emit(state.copyWith(
            status: SecurityStatus.lockedOut,
            failedAttempts: newFailedAttempts,
            errorMessage: 'Demasiados intentos fallidos. App bloqueada.',
          ));
        } else {
          emit(state.copyWith(
            status: SecurityStatus.unauthenticated,
            failedAttempts: newFailedAttempts,
            errorMessage: 'PIN incorrecto. Intento $newFailedAttempts de 5.',
          ));
        }
      }
    } catch (_) {
      emit(state.copyWith(status: SecurityStatus.error));
    }
  }

  Future<void> _onAuthenticateWithBiometrics(
    SecurityAuthenticateWithBiometrics event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      final authenticated = await _securityVault.authenticateWithBiometrics(
        reason: 'Autentícate para acceder a Serenti',
      );
      if (authenticated) {
        emit(state.copyWith(status: SecurityStatus.authenticated));
      }
    } catch (_) {
      // Fallback to manual PIN entry happens naturally by not changing state to authenticated
    }
  }

  Future<void> _onToggleBiometrics(
    SecurityToggleBiometrics event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      await _securityVault.setBiometricEnabled(enabled: event.enabled);
      emit(state.copyWith(isBiometricEnabled: event.enabled));
    } catch (_) {
      emit(state.copyWith(status: SecurityStatus.error));
    }
  }
}
