# Story 2.2: Test PHQ-9 Inicial con Sliders Empáticos

Status: done

## Story

Como usuario,
quiero completar mi primer test de salud mental usando una interfaz amable donde Milo reaccione a mis respuestas,
para que el sistema establezca mi línea base de bienestar de forma empática y no clínica.

## Acceptance Criteria

1. **Interfaz de Sliders Empáticos:** Implementar un flujo de 9 preguntas (PHQ-9) donde cada respuesta se seleccione mediante un slider (0-3). [Source: _bmad-output/planning-artifacts/ux-design-specification.md#UX-DR8]
2. **Reacción de Milo en Tiempo Real:** La expresión visual de Milo debe cambiar (Idle, Joy, Rest, Shelter) o mediante animaciones sutiles según el valor seleccionado en el slider actual. [Source: _bmad-output/planning-artifacts/epics.md#Story 2.2]
3. **Persistencia Cifrada:** El resultado total del test y las respuestas individuales deben guardarse en Isar con cifrado AES-256. [Source: _bmad-output/planning-artifacts/prd.md#Phase 1]
4. **Cálculo de Score:** El sistema debe calcular el score total (0-27) y determinar el nivel de severidad inicial.
5. **Navegación Post-Test:** Al finalizar, el usuario debe ser redirigido al siguiente paso del onboarding o al hábitat si es el último paso.

## Tasks / Subtasks

- [x] **Data Model Implementation (AC: 3, 4)**
  - [x] Crear el modelo `Phq9Result` en `serenti/packages/isar_database/lib/src/models/phq9_result.dart`.
  - [x] Registrar `Phq9ResultSchema` en `serenti/packages/isar_database/lib/src/isar_database.dart`.
  - [x] Ejecutar `build_runner` en `isar_database`.
- [x] **Business Logic (BLoC) (AC: 2, 4, 5)**
  - [x] Crear `Phq9Bloc` en `serenti/lib/app/logic/phq9/phq9_bloc.dart`.
  - [x] Implementar eventos: `Phq9AnswerUpdated`, `Phq9SubmitTest`.
  - [x] Lógica para calcular severidad y persistir mediante `PetRepository` o un nuevo `Phq9Repository`.
- [x] **UI Implementation (AC: 1, 2)**
  - [x] Crear `Phq9TestPage` en `serenti/lib/app/view/phq9/phq9_test_page.dart`.
  - [x] Diseñar el componente `EmpatheticSlider` que comunique cambios a Milo.
  - [x] Implementar visualización de Milo reactivo a la selección actual.
  - [x] Estilo visual: Nunito font, bordes 24px, paleta "Refugio Visual".
- [x] **Verification & Testing (AC: 1-5)**
  - [x] Unit tests para el cálculo de score en el Bloc.
  - [x] Widget tests para asegurar que el slider actualiza la UI de Milo.
  - [x] Test de persistencia cifrada.

## Dev Notes

- **PHQ-9 Questions:** Las 9 preguntas estándar deben estar localizadas en los archivos `arb`.
- **Milo States:** Usar `CustomPainter` o assets SVG/Lottie según disponibilidad para las reacciones.
- **Security:** Reutilizar la clave de cifrado de la bóveda de seguridad para Isar.

### Project Structure Notes

- Seguir la estructura modular y de carpetas establecida en la Story 2.1.
- Localizar todas las preguntas del test en `serenti/lib/l10n/arb/`.

### References

- [Source: _bmad-output/planning-artifacts/prd.md#FR1]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#UX-DR8]
- [Source: _bmad-output/planning-artifacts/epics.md#Epic 2]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash

### Debug Log References

### Completion Notes List

### File List
