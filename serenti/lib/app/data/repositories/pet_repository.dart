import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:security_vault/security_vault.dart';

class PetRepository {
  PetRepository({
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

  Future<PetProfile?> getPetProfile() async {
    final isar = await _getIsar();
    return isar.petProfiles.where().findFirst();
  }

  Future<void> savePetProfile({
    required String name,
    required PetGender gender,
  }) async {
    final isar = await _getIsar();
    final existingProfile = await getPetProfile();
    
    final profile = existingProfile ?? PetProfile()
      ..name = name
      ..gender = gender;

    if (existingProfile != null) {
      profile.name = name;
      profile.gender = gender;
    }

    await isar.writeTxn(() async {
      await isar.petProfiles.put(profile);
      
      // Update UserSettings to mark pet as customized
      final settings = await isar.userSettings.where().findFirst();
      if (settings != null) {
        settings.petCustomized = true;
        // Remove from pending steps if exists
        final updatedSteps = List<String>.from(settings.pendingSteps);
        if (updatedSteps.remove('personalization')) {
          settings.pendingSteps = updatedSteps;
        }
        await isar.userSettings.put(settings);
      }
    });
  }
}
