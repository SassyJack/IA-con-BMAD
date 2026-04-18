// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:tflite_service/tflite_service.dart';

void main() {
  group('TfliteService', () {
    test('can be instantiated', () {
      expect(TfliteService(), isNotNull);
    });
  });
}
