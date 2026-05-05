import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:security_vault/security_vault.dart';
import 'package:serenti/app/logic/security/security_bloc.dart';

class MockSecurityVault extends Mock implements SecurityVault {}

void main() {
  late SecurityBloc securityBloc;
  late MockSecurityVault mockSecurityVault;

  setUp(() {
    mockSecurityVault = MockSecurityVault();
    securityBloc = SecurityBloc(securityVault: mockSecurityVault);
  });

  group('Security System Persistent Lock', () {
    test('initializes as lockedOut when failed attempts are >= 5', () async {
      // Setup: Storage already has 5 failed attempts
      when(() => mockSecurityVault.hasPinSet()).thenAnswer((_) async => true);
      when(() => mockSecurityVault.getFailedAttempts()).thenAnswer((_) async => 5);
      when(() => mockSecurityVault.isBiometricEnabled()).thenAnswer((_) async => false);

      // Act: Trigger status check (happens on app start)
      securityBloc.add(SecurityCheckStatus());

      // Assert: The state should transition to lockedOut despite being a fresh start
      await expectLater(
        securityBloc.stream,
        emitsInOrder([
          isA<SecurityState>().having((s) => s.status, 'status', SecurityStatus.loading),
          isA<SecurityState>().having((s) => s.status, 'status', SecurityStatus.lockedOut),
        ]),
      );
      
      expect(securityBloc.state.failedAttempts, 5);
      expect(securityBloc.state.errorMessage, contains('App bloqueada'));
    });

    test('resets failed attempts when correct PIN is entered', () async {
      when(() => mockSecurityVault.hasPinSet()).thenAnswer((_) async => true);
      when(() => mockSecurityVault.getFailedAttempts()).thenAnswer((_) async => 2);
      when(() => mockSecurityVault.isBiometricEnabled()).thenAnswer((_) async => false);
      when(() => mockSecurityVault.verifyPin('1234')).thenAnswer((_) async => true);
      when(() => mockSecurityVault.resetFailedAttempts()).thenAnswer((_) async => {});

      securityBloc.add(SecurityCheckStatus());
      await tick(); // Wait for initialization

      securityBloc.add(const SecurityAuthenticateWithPin('1234'));

      await expectLater(
        securityBloc.stream,
        emitsThrough(
          isA<SecurityState>().having((s) => s.status, 'status', SecurityStatus.authenticated),
        ),
      );

      verify(() => mockSecurityVault.resetFailedAttempts()).called(1);
      expect(securityBloc.state.failedAttempts, 0);
    });
  });
}

/// Helper to wait for microtasks
Future<void> tick() => Future<void>.delayed(Duration.zero);
