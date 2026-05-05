import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tflite_service/tflite_service.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';
import 'package:isar_database/isar_database.dart';

void main() {
  group('Serenti Core Performance Profiling', () {
    late TfliteService tfliteService;
    late InferenceRepository inferenceRepository;

    setUp(() {
      tfliteService = MockTfliteService();
      // No necesitamos Isar real para medir el impacto de CPU/RAM de la IA y el Preproceso
      inferenceRepository = InferenceRepository(
        isarDatabase: MockIsarDatabase(),
        tfliteService: tfliteService,
      );
    });

    test('Profiling: Preprocess + TFLite Predict Impact', () async {
      print('\n--- INICIO DE PROFILING DE CORE AI ---');
      
      final initialMemory = ProcessInfo.currentRss;
      int totalIterations = 1000; // Más iteraciones para mayor precisión
      
      // Datos de entrada simulados (24 horas de datos)
      final dummyData = List.generate(400, (index) => SensorData()
        ..source = SensorDataSource.values[index % 3]
        ..timestamp = DateTime.now()
        ..stepCount = 10);

      when(() => tfliteService.predict(any())).thenAnswer((_) async => const InferenceResult(
        mood: MiloInferenceMood.joy,
        confidence: 0.9,
      ));

      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < totalIterations; i++) {
        // Medimos el pipeline que realmente consume CPU
        final input = inferenceRepository.preprocess(dummyData);
        await tfliteService.predict(input);
      }

      final elapsed = stopwatch.elapsedMilliseconds;
      final finalMemory = ProcessInfo.currentRss;
      final avgTime = elapsed / totalIterations;
      final memoryDeltaMB = (finalMemory - initialMemory) / (1024 * 1024);

      print('Resultados de Profiling (Pipeline IA):');
      print('  - Tiempo Promedio por ciclo: ${avgTime.toStringAsFixed(4)}ms');
      print('  - Latencia Total (1000 ciclos): ${elapsed}ms');
      print('  - Incremento RAM (RSS): ${memoryDeltaMB.toStringAsFixed(4)} MB');

      // Validamos contra NFR1 (aunque esto es solo core, el total incluye Isar)
      expect(avgTime, lessThan(10), reason: 'El core de IA es demasiado lento');
      expect(memoryDeltaMB, lessThan(2), reason: 'Fuga de memoria en el pipeline de IA');
      
      print('--- FIN DE PROFILING ---\n');
    });
  });
}

class MockTfliteService extends Mock implements TfliteService {}
class MockIsarDatabase extends Mock implements IsarDatabase {}
