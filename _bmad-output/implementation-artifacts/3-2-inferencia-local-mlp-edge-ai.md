# Story 3.2: Inferencia Local MLP (Edge AI)

Status: done

## Story

Como **sistema**,
quiero **ejecutar el modelo TFLite cada 6 horas en un Isolate dedicado**,
para **actualizar el estado emocional de Milo basándose en los metadatos recolectados sin bloquear la interfaz**.

## Acceptance Criteria

1. Integrar el modelo MLP cuantizado (`.tflite`) en el paquete `tflite_service`.
2. Ejecutar la inferencia en un `Isolate` dedicado para cumplir con NFR1 (Inferencia < 100ms).
3. Implementar la lógica de pre-procesamiento de datos (normalización de metadatos de sensores).
4. El resultado de la inferencia debe guardarse en `isar_database` en una nueva colección `MiloState`.
5. El sistema debe disparar la inferencia automáticamente cada 6 horas.
6. Operación 100% offline.

## Tasks / Subtasks

- [x] **Persistencia: Esquema MiloState** (AC: #4)
  - [x] Crear `serenti/packages/isar_database/lib/src/models/milo_state.dart` with fields: `timestamp`, `mood` (enum: idle, joy, rest, shelter), `confidenceScore`.
  - [x] Integrar `MiloStateSchema` en `IsarDatabase.getInstance()`.
  - [x] Ejecutar `dart run build_runner build` en `isar_database`.
- [x] **Implementación TFLite Service** (AC: #1, #2, #3)
  - [x] Añadir el archivo del modelo MLP a los assets de `tflite_service`.
  - [x] Implementar `TfliteService` en `serenti/packages/tflite_service/lib/src/tflite_service.dart`.
  - [x] Configurar el uso de `Interpreter` y ejecución en un `Isolate` (usando `compute` o `Isolate.spawn`).
  - [x] Implementar el mapeo de la salida del modelo (probabilidades) a los estados de Milo.
- [x] **Lógica de Inferencia y Orquestación** (AC: #5)
  - [x] Crear un `InferenceRepository` en la app principal para coordinar: lectura de `SensorData` -> Inferencia -> Guardado en `MiloState`.
  - [x] Implementar la lógica de agregación de datos de las últimas 6 horas para la entrada del modelo.
  - [x] Configurar la ejecución periódica (puedes usar un `Timer` persistente o integrar con la lógica de bootstrap).
- [x] **Pruebas y Validación**
  - [x] Unit tests para el pre-procesamiento de datos (preprocess).
  - [x] Validación de la estructura de MiloState en Isar.


## Dev Notes

- **Modelo:** El modelo debe cargarse desde assets de forma eficiente.
- **Isolates:** Es crítico para no causar "jank" en las animaciones de 60 FPS (NFR2).
- **Mapeo de Salida:** Si la salida es un vector de probabilidades, elegir el estado con mayor confianza.

### Project Structure Notes

- `MiloState` model en `isar_database`.
- `TfliteService` en `tflite_service`.
- Orquestación en `serenti/lib/app/data/repositories/inference_repository.dart`.

### References

- [Source: _bmad-output/planning-artifacts/prd.md#Functional Requirements] (FR5)
- [Source: _bmad-output/planning-artifacts/architecture.md#Edge AI]
- [Source: _bmad-output/planning-artifacts/epics.md#Epic 3: Inteligencia Silenciosa]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
