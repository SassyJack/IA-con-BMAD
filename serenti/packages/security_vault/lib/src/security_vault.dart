import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// {@template security_vault}
/// Package responsible for secure key storage and biometric authentication.
/// {@endtemplate}
class SecurityVault {
  /// {@macro security_vault}
  SecurityVault({
    FlutterSecureStorage? storage,
    LocalAuthentication? localAuth,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _localAuth = localAuth ?? LocalAuthentication();

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  static const _encryptionKeyName = 'serenti_database_key';
  static const _pinHashName = 'serenti_pin_hash';
  static const _biometricEnabledName = 'serenti_biometric_enabled';
  static const _failedAttemptsName = 'serenti_failed_attempts';
  static const _pinSalt = 'serenti_security_salt_2026';

  /// Returns the encryption key for Isar database.
  /// Generates a new one if it doesn't exist.
  Future<Uint8List> getDatabaseEncryptionKey() async {
    final existingKey = await _storage.read(key: _encryptionKeyName);

    if (existingKey != null) {
      return base64Decode(existingKey);
    }

    final newKey = _generateSecureKey();
    await _storage.write(
      key: _encryptionKeyName,
      value: base64Encode(newKey),
    );

    return newKey;
  }

  /// Sets the PIN hash in secure storage.
  Future<void> setPin(String pin) async {
    final bytes = utf8.encode(pin + _pinSalt);
    final digest = sha256.convert(bytes);
    await _storage.write(key: _pinHashName, value: digest.toString());
    await resetFailedAttempts();
  }

  /// Checks if a PIN has been set.
  Future<bool> hasPinSet() async {
    final hash = await _storage.read(key: _pinHashName);
    return hash != null;
  }

  /// Verifies the provided PIN against the stored hash.
  Future<bool> verifyPin(String pin) async {
    final storedHash = await _storage.read(key: _pinHashName);
    if (storedHash == null) return false;
    
    final bytes = utf8.encode(pin + _pinSalt);
    final providedHash = sha256.convert(bytes).toString();
    return storedHash == providedHash;
  }

  /// Returns the number of failed attempts stored.
  Future<int> getFailedAttempts() async {
    final stored = await _storage.read(key: _failedAttemptsName);
    return int.tryParse(stored ?? '0') ?? 0;
  }

  /// Increments and stores the number of failed attempts.
  Future<int> incrementFailedAttempts() async {
    final current = await getFailedAttempts();
    final next = current + 1;
    await _storage.write(key: _failedAttemptsName, value: next.toString());
    return next;
  }

  /// Resets the failed attempts counter to zero.
  Future<void> resetFailedAttempts() async {
    await _storage.write(key: _failedAttemptsName, value: '0');
  }

  /// Authenticates the user using biometrics.
  Future<bool> authenticateWithBiometrics({
    required String reason,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// Checks if biometric authentication is enabled.
  Future<bool> isBiometricEnabled() async {
    final enabled = await _storage.read(key: _biometricEnabledName);
    return enabled == 'true';
  }

  /// Sets whether biometric authentication is enabled.
  Future<void> setBiometricEnabled({required bool enabled}) async {
    await _storage.write(
      key: _biometricEnabledName,
      value: enabled.toString(),
    );
  }

  Uint8List _generateSecureKey() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(32, (i) => random.nextInt(256)),
    );
  }
}
