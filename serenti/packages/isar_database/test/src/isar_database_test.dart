// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:isar_database/isar_database.dart';
import 'package:test/test.dart';

void main() {
  group('IsarDatabase', () {
    test('can be instantiated', () {
      expect(IsarDatabase(), isNotNull);
    });
  });
}
