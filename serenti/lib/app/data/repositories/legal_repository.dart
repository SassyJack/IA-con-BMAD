import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:security_vault/security_vault.dart';

class LegalRepository {
  LegalRepository({
    required IsarDatabase isarDatabase,
    required SecurityVault securityVault,
  })  : _isarDatabase = isarDatabase,
        _securityVault = securityVault;

  final IsarDatabase _isarDatabase;
  final SecurityVault _securityVault;

  Future<Isar> _getIsar() async {
    final key = await _securityVault.getDatabaseEncryptionKey();
    return _isarDatabase.getInstance(encryptionKey: key);
  }

  Future<bool> hasAcceptedConsent() async {
    final isar = await _getIsar();
    final consent = await isar.legalConsents.where().findFirst();
    return consent?.isAccepted ?? false;
  }

  Future<void> acceptConsent() async {
    final isar = await _getIsar();
    final consent = LegalConsent()
      ..isAccepted = true
      ..acceptedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.legalConsents.put(consent);
    });
  }
}
