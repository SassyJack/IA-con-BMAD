import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:security_vault/security_vault.dart';

class Phq9Repository {
  Phq9Repository({
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

  Future<Phq9Result?> getLatestResult() async {
    final isar = await _getIsar();
    return isar.phq9Results.where().sortByDateDesc().findFirst();
  }

  Future<void> saveResult({
    required List<int> answers,
    required int totalScore,
  }) async {
    final isar = await _getIsar();
    
    final result = Phq9Result()
      ..date = DateTime.now()
      ..answers = answers
      ..totalScore = totalScore
      ..severity = _getSeverity(totalScore);

    await isar.writeTxn(() async {
      await isar.phq9Results.put(result);
      
      // Update UserSettings to mark PHQ-9 as completed in onboarding
      final settings = await isar.userSettings.where().findFirst();
      if (settings != null) {
        settings.pendingSteps.remove('phq9_test');
        if (settings.pendingSteps.isEmpty) {
          settings.isOnboardingComplete = true;
        }
        await isar.userSettings.put(settings);
      }
    });
  }

  String _getSeverity(int score) {
    if (score <= 4) return 'Minimal';
    if (score <= 9) return 'Leve';
    if (score <= 14) return 'Moderada';
    if (score <= 19) return 'Moderadamente Severa';
    return 'Severa';
  }
}
