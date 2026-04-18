import 'dart:io';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('Isar Integration Test', () {
    late Isar isar;
    late IsarDatabase isarDatabase;
    late Directory tempDir;

    setUp(() async {
      // Create a temporary directory for the test
      tempDir = await Directory.systemTemp.createTemp('isar_test');
      isarDatabase = IsarDatabase();
      
      // Open Isar with the temporary directory
      // Note: In unit tests on a machine, we need the isar library binary.
      // For local development, this usually requires 'isar_flutter_libs' 
      // or manually downloading the binary.
      // Since this is a demonstration of configuration, we'll try to open it.
      try {
        isar = await isarDatabase.getInstance(directory: tempDir.path);
      } catch (e) {
        if (e.toString().contains('library')) {
          markTestSkipped('Isar binary not found. This test requires the isar library binary in the path.');
        } else {
          rethrow;
        }
      }
    });

    tearDown(() async {
      await isarDatabase.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('can perform real database operations', () async {
      final state = MiloState()
        ..timestamp = DateTime.now()
        ..mood = MiloMood.joy
        ..confidenceScore = 0.95;

      await isar.writeTxn(() async {
        await isar.miloStates.put(state);
      });

      final retrieved = await isar.miloStates.where().findFirst();
      expect(retrieved, isNotNull);
      expect(retrieved!.mood, MiloMood.joy);
      expect(retrieved.confidenceScore, 0.95);
    });
  });
}
