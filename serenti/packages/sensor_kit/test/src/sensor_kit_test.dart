// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:sensor_kit/sensor_kit.dart';
import 'package:test/test.dart';

void main() {
  group('SensorKit', () {
    test('can be instantiated', () {
      expect(SensorKit(), isNotNull);
    });
  });
}
