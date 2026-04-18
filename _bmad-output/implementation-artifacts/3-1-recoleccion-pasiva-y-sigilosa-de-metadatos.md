# Story 3.1: Recolección Pasiva y Sigilosa de Metadatos

Status: done

## Story

Como **sistema**,
quiero **recolectar datos de movilidad, actividad y socialización en segundo plano sin agotar la batería (<5% diario)**,
para **alimentar el modelo MLP local con datos de comportamiento para el monitoreo pasivo de salud mental**.

## Acceptance Criteria

1. Implementar recolección de movilidad usando `geolocator` (GPS/distancia recorrida).
2. Implementar recolección de actividad física usando `pedometer` (pasos diarios).
3. Implementar recolección de metadatos de socialización (e.g., frecuencia de llamadas/mensajes usando `phone_state` o similar en Android; fallback silencioso en iOS).
4. Los datos deben almacenarse de forma cifrada en `isar_database` mediante el esquema `SensorData`.
5. Optimización de frecuencia de muestreo para asegurar un consumo de batería <5% diario.
6. Operación 100% offline (NFR3).

## Tasks / Subtasks

- [x] **Persistencia: Esquema SensorData** (AC: #4)
  - [x] Crear `serenti/packages/isar_database/lib/src/models/sensor_data.dart` con campos para: `timestamp`, `latitude`, `longitude`, `stepCount`, `socialActivityCount`, `source` (enum).
  - [x] Integrar `SensorDataSchema` en `IsarDatabase.getInstance()`.
  - [x] Ejecutar `dart run build_runner build` en `isar_database`.
- [x] **Implementación SensorKit** (AC: #1, #2, #3, #5)
  - [x] Crear `SensorKitService` en `serenti/packages/sensor_kit/lib/src/sensor_kit_service.dart`.
  - [x] Implementar flujo de `geolocator` con configuración de bajo consumo (e.g., `LocationSettings(accuracy: LocationAccuracy.balanced, distanceFilter: 100)`).
  - [x] Implementar flujo de `pedometer` para capturar eventos de pasos.
  - [x] Investigar e implementar recolección mínima de socialización (e.g., usando `phone_state` para Android).
  - [x] Añadir permisos necesarios en `AndroidManifest.xml` e `Info.plist`.
- [x] **Integración y Lógica de Segundo Plano** (AC: #5, #6)
  - [x] Implementar un `SensorRepository` o similar que coordine la captura y el guardado en Isar.
  - [x] Asegurar que la recolección persista al cerrar la app (puedes usar `workmanager` o similar si es necesario, pero para el MVP se puede iniciar en el bootstrap y mantener vivo mientras la app esté en background).
- [x] **Pruebas y Validación**
  - [x] Unit tests en `packages/sensor_kit/test`.
  - [x] Integration test básico que verifique que los datos se guardan en Isar.

## Dev Notes

- **Patrón:** Seguir el patrón de paquetes modulares. El `sensor_kit` no debe depender directamente de `isar_database` para evitar dependencias circulares; inyectar la dependencia de persistencia o usar un stream que la app principal escuche.
- **Eficiencia Energética:** El GPS es el mayor consumidor. Usar `distanceFilter` alto (100m+) y precisión balanceada.
- **Seguridad:** Los datos en Isar ya están cifrados por la implementación de la Épica 1.

### Project Structure Notes

- Mantener la separación en `/packages`.
- `SensorData` model en `isar_database`.
- `SensorKit` logic en `sensor_kit`.

### References

- [Source: _bmad-output/planning-artifacts/prd.md#Functional Requirements] (FR4)
- [Source: _bmad-output/planning-artifacts/epics.md#Epic 3: Inteligencia Silenciosa]
- [Source: _bmad-output/planning-artifacts/architecture.md]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
