# Story 3.3: Calibración de Línea Base (Periodo de Gracia)

Status: done

## Story

Como **sistema**,
quiero **recolectar datos durante 7 días antes de establecer una línea base definitiva**,
para **evitar falsas alertas iniciales y asegurar que Milo refleje mi bienestar real tras conocerme mejor**.

## Acceptance Criteria

1. Implementar la persistencia de la fecha de inicio de la recolección en `isar_database`.
2. El sistema debe marcar el estado como "Calibrando" durante los primeros 7 días tras el onboarding legal.
3. Durante este periodo, Milo debe mostrar un estado de "Conociéndote" o similar (feedback visual).
4. La lógica de inferencia debe considerar este periodo de gracia antes de disparar alertas de riesgo.
5. Al finalizar los 7 días, el sistema debe calcular la línea base inicial de comportamiento.

## Tasks / Subtasks

- [x] **Persistencia: Calibración en UserSettings** (AC: #1)
  - [x] Añadir campo `calibrationStartDate` a `serenti/packages/isar_database/lib/src/models/user_settings.dart`.
  - [x] Ejecutar `dart run build_runner build` en `isar_database`.
- [x] **Lógica de Periodo de Gracia** (AC: #2, #4)
  - [x] Actualizar `serenti/lib/app/data/repositories/inference_repository.dart` para verificar si han pasado 7 días desde `calibrationStartDate`.
  - [x] Si está en periodo de gracia, guardar `MiloMood.idle` (u otro estado neutro) con una nota de calibración.
- [x] **Feedback Visual "Conociéndote"** (AC: #3)
  - [x] Implementar un indicador visual o diálogo en el Habitat que informe al usuario que Milo está en fase de aprendizaje.
- [x] **Cálculo de Línea Base Inicial** (AC: #5)
  - [x] Implementar la lógica que se dispara al cumplirse los 7 días para establecer los promedios iniciales de movilidad y actividad.
- [x] **Pruebas y Validación**
  - [x] Unit tests para la lógica de cálculo de días transcurridos (OnboardingBloc).
  - [x] Validación de la transición de estado "Calibrando" a "Activo" mediante lógica de repositorio.

## Dev Notes

- **Periodo de Gracia:** Es fundamental para la retención del usuario (no dar alertas erróneas pronto).
- **UX:** El feedback debe ser positivo, tipo "Milo está aprendiendo tus rutinas".

### Project Structure Notes

- Actualización en `user_settings` de `isar_database`.
- Lógica extendida en `InferenceRepository`.

### References

- [Source: _bmad-output/planning-artifacts/prd.md#Functional Requirements] (FR2)
- [Source: _bmad-output/planning-artifacts/epics.md#Story 3.3: Calibración de Línea Base]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
