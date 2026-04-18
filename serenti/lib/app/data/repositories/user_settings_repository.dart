import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:security_vault/security_vault.dart';

class UserSettingsRepository {
  UserSettingsRepository({
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

  Future<UserSettings> getUserSettings() async {
    final isar = await _getIsar();
    final settings = await isar.userSettings.where().findFirst();
    
    if (settings == null) {
      final newSettings = UserSettings()
        ..isOnboardingComplete = false
        ..petCustomized = false
        ..pendingSteps = ['personalization', 'phq9_test', 'welcome_dialogue', 'habitat_setup'];
      
      await isar.writeTxn(() async {
        await isar.userSettings.put(newSettings);
      });
      return newSettings;
    }
    
    return settings;
  }

  Future<void> updateOnboardingStatus({
    required bool isComplete,
    List<String>? pendingSteps,
  }) async {
    final isar = await _getIsar();
    final settings = await getUserSettings();
    
    settings.isOnboardingComplete = isComplete;
    if (pendingSteps != null) {
      settings.pendingSteps = pendingSteps;
    }

    await isar.writeTxn(() async {
      await isar.userSettings.put(settings);
    });
  }

  Future<void> updateNotificationIntensity(double intensity) async {
    final isar = await _getIsar();
    final settings = await getUserSettings();
    
    settings.notificationIntensity = intensity;

    await isar.writeTxn(() async {
      await isar.userSettings.put(settings);
    });
  }
}
