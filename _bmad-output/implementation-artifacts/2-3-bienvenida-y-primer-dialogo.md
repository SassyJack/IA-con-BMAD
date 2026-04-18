# Story 2.3: Bienvenida y Primer Diálogo

Status: ready-for-dev

## Story

Como usuario,
quiero que Milo se presente y me explique brevemente cómo me acompañará,
para sentirme bienvenido y entender el propósito de la aplicación desde el primer momento.

## Acceptance Criteria

1. **Secuencia de Diálogos de Bienvenida:** Tras completar la personalización y el PHQ-9, debe dispararse una secuencia de diálogos (mínimo 3 burbujas) donde Milo usa su nombre y género seleccionados. [Source: _bmad-output/planning-artifacts/epics.md#Story 2.3]
2. **Animaciones de Milo:** Durante los diálogos, Milo debe alternar entre los estados "Joy" e "Idle" para transmitir empatía y calidez. [Source: _bmad-output/planning-artifacts/ux-design-specification.md#UX-DR4]
3. **Persistencia del Estado de Bienvenida:** El sistema debe marcar que el diálogo de bienvenida ha sido completado para no repetirlo innecesariamente.
4. **Finalización del Onboarding Inicial:** Al terminar el diálogo, el usuario debe entrar formalmente al Hábitat por primera vez. [Source: _bmad-output/planning-artifacts/epics.md#Story 1.4]
5. **Estilo de Diálogo:** Las burbujas de diálogo deben seguir el sistema de diseño: bordes redondeados (24px), fuente Nunito, y colores de la paleta "Refugio Visual".

## Tasks / Subtasks

- [x] **Business Logic (BLoC) (AC: 1, 3, 4)**
  - [x] Extender `PetBloc` o crear un `DialogueBloc` en `serenti/lib/app/logic/dialogue/dialogue_bloc.dart` para gestionar secuencias de texto.
  - [x] Implementar la lógica para navegar a través de la secuencia de diálogos.
  - [x] Integrar con `UserSettingsRepository` para persistir la finalización del onboarding.
- [x] **UI Implementation (AC: 1, 2, 5)**
  - [x] Crear `WelcomeDialoguePage` en `serenti/lib/app/view/dialogue/welcome_dialogue_page.dart`.
  - [x] Implementar componente `DialogueBubble` con animaciones de entrada sutiles.
  - [x] Integrar visualización de Milo animado reactivo al avance del diálogo.
- [x] **Verification & Testing (AC: 1-5)**
  - [x] Unit tests para la lógica de avance de la secuencia de diálogos.
  - [x] Widget tests para verificar la visualización correcta de los textos localizados.
  - [x] Verificar la transición final al Hábitat.

## Dev Notes

- **Diálogos:** Los textos deben estar en archivos `arb` y permitir la interpolación de variables como el nombre de la mascota.
- **Transiciones:** Usar `page_transition` o animaciones integradas de Flutter para un flujo suave entre burbujas.
- **Onboarding completion:** Este es el paso final del flujo inicial. Asegurarse de actualizar `isOnboardingComplete` en la base de datos Isar.

### Project Structure Notes

- Seguir el patrón de carpetas modular establecido en las stories anteriores.
- Localizar diálogos en `serenti/lib/l10n/arb/`.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 2]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Mascota Milo]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash

### Debug Log References

### Completion Notes List

### File List
