import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:security_vault/security_vault.dart';
import 'package:test/test.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockLocalAuthentication extends Mock implements LocalAuthentication {}
class FakeAuthenticationOptions extends Fake implements AuthenticationOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthenticationOptions());
  });

  group('SecurityVault', () {
    late FlutterSecureStorage storage;
    late LocalAuthentication localAuth;
    late SecurityVault securityVault;

    setUp(() {
      storage = MockFlutterSecureStorage();
      localAuth = MockLocalAuthentication();
      securityVault = SecurityVault(storage: storage, localAuth: localAuth);
    });

    test('can be instantiated', () {
      expect(SecurityVault(), isNotNull);
    });

    group('getDatabaseEncryptionKey', () {
      test('returns existing key when available', () async {
        final key = Uint8List.fromList(List.generate(32, (i) => i));
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => base64Encode(key));

        final result = await securityVault.getDatabaseEncryptionKey();

        expect(result, equals(key));
        verify(() => storage.read(key: 'serenti_database_key')).called(1);
      });

      test('generates and saves new key when not available', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);
        when(() => storage.write(
              key: any(named: 'key'),
              value: any(named: 'value'),
            )).thenAnswer((_) async {});

        final result = await securityVault.getDatabaseEncryptionKey();

        expect(result.length, equals(32));
        verify(() => storage.read(key: 'serenti_database_key')).called(1);
        verify(() => storage.write(
              key: 'serenti_database_key',
              value: any(named: 'value'),
            )).called(1);
      });
    });

    group('PIN', () {
      test('setPin saves hashed pin', () async {
        when(() => storage.write(
              key: any(named: 'key'),
              value: any(named: 'value'),
            )).thenAnswer((_) async {});

        await securityVault.setPin('1234');

        verify(() => storage.write(
              key: 'serenti_pin_hash',
              value: any(named: 'value'),
            )).called(1);
      });

      test('hasPinSet returns true if pin hash exists', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => 'some_hash');

        final result = await securityVault.hasPinSet();

        expect(result, isTrue);
        verify(() => storage.read(key: 'serenti_pin_hash')).called(1);
      });

      test('verifyPin returns true for correct pin', () async {
        const pin = '1234';
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => base64Encode(utf8.encode(pin)));

        final result = await securityVault.verifyPin(pin);

        expect(result, isTrue);
      });
    });

    group('Biometrics', () {
      test('authenticateWithBiometrics calls localAuth', () async {
        when(() => localAuth.authenticate(
              localizedReason: any(named: 'localizedReason'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => true);

        final result = await securityVault.authenticateWithBiometrics(
          reason: 'Test reason',
        );

        expect(result, isTrue);
        verify(() => localAuth.authenticate(
              localizedReason: 'Test reason',
              options: any(named: 'options'),
            )).called(1);
      });

      test('isBiometricEnabled returns value from storage', () async {
        when(() => storage.read(key: any(named: 'key')))
            .thenAnswer((_) async => 'true');

        final result = await securityVault.isBiometricEnabled();

        expect(result, isTrue);
        verify(() => storage.read(key: 'serenti_biometric_enabled')).called(1);
      });

      test('setBiometricEnabled saves value to storage', () async {
        when(() => storage.write(
              key: any(named: 'key'),
              value: any(named: 'value'),
            )).thenAnswer((_) async {});

        await securityVault.setBiometricEnabled(enabled: true);

        verify(() => storage.write(
              key: 'serenti_biometric_enabled',
              value: 'true',
            )).called(1);
      });
    });
  });
}
