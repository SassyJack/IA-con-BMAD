import 'dart:typed_data';
import 'package:isar/isar.dart';
import 'package:isar_database/src/models/legal_consent.dart';
import 'package:isar_database/src/models/milo_state.dart';
import 'package:isar_database/src/models/pet_profile.dart';
import 'package:isar_database/src/models/phq9_result.dart';
import 'package:isar_database/src/models/sensor_data.dart';
import 'package:isar_database/src/models/user_settings.dart';
import 'package:path_provider/path_provider.dart';

/// {@template isar_database}
/// Service responsible for managing Isar database connection and schemas.
/// {@endtemplate}
class IsarDatabase {
  Isar? _isar;

  /// Returns the Isar instance. Opens it if it's not already open.
  /// 
  /// [directory] can be provided to override the default application 
  /// documents directory (useful for testing).
  Future<Isar> getInstance({
    Uint8List? encryptionKey,
    String? directory,
  }) async {
    if (_isar != null && _isar!.isOpen) return _isar!;

    final path = directory ?? (await getApplicationDocumentsDirectory()).path;
    
    _isar = await Isar.open(
      [
        LegalConsentSchema,
        UserSettingsSchema,
        PetProfileSchema,
        Phq9ResultSchema,
        SensorDataSchema,
        MiloStateSchema,
      ],
      directory: path,
      name: 'serenti_db',
      inspector: true, // Enable inspector for debug builds
    );

    return _isar!;
  }

  /// Closes the Isar instance.
  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
    }
  }
}
