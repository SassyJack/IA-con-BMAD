import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_kit/sensor_kit.dart';
import 'package:serenti/app/data/repositories/sensor_repository.dart';

class MockIsarDatabase extends Mock implements IsarDatabase {}
class MockIsar extends Mock implements Isar {}
class MockIsarCollection extends Mock implements IsarCollection<SensorData> {}
class MockSensorKitService extends Mock implements SensorKitService {}

void main() {
  late IsarDatabase isarDatabase;
  late Isar isar;
  late IsarCollection<SensorData> collection;
  late SensorKitService sensorKitService;
  late SensorRepository sensorRepository;

  setUpAll(() {
    registerFallbackValue(SensorData());
    registerFallbackValue(() async => 1);
  });

  setUp(() {
    isarDatabase = MockIsarDatabase();
    isar = MockIsar();
    collection = MockIsarCollection();
    sensorKitService = MockSensorKitService();
    
    when(() => isarDatabase.getInstance()).thenAnswer((_) async => isar);
    when(() => isar.sensorDatas).thenReturn(collection);
    
    sensorRepository = SensorRepository(
      isarDatabase: isarDatabase,
      sensorKitService: sensorKitService,
    );
  });

  group('SensorRepository', () {
    test('startCollection starts service and listens to events', () async {
      final controller = StreamController<SensorEvent>();
      when(() => sensorKitService.sensorEvents).thenAnswer((_) => controller.stream);
      when(() => sensorKitService.start()).thenAnswer((_) async {});
      when(() => isar.writeTxn<int>(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Future<int> Function();
        return callback();
      });
      when(() => collection.put(any())).thenAnswer((_) async => 1);

      await sensorRepository.startCollection();

      final event = SensorEvent(
        type: SensorType.activity,
        timestamp: DateTime.now(),
        stepCount: 100,
      );

      controller.add(event);
      
      // Wait for async processing
      await Future<void>.delayed(const Duration(milliseconds: 100));

      verify(() => sensorKitService.start()).called(1);
      verify(() => collection.put(any())).called(1);
      
      await controller.close();
    });

    test('stopCollection stops service and subscription', () async {
      when(() => sensorKitService.start()).thenAnswer((_) async {});
      when(() => sensorKitService.stop()).thenAnswer((_) async {});
      when(() => sensorKitService.sensorEvents).thenAnswer((_) => const Stream.empty());

      await sensorRepository.startCollection();
      await sensorRepository.stopCollection();

      verify(() => sensorKitService.stop()).called(1);
    });
  });
}
