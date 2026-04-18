# Story 1.4: Onboarding Ágil y Flexible

Status: ready-for-dev

## Story

As a Usuario,
I want poder saltar la personalización inicial para ver a mi mascota rápidamente,
so that reducir la fricción inicial y conocer a Milo sin comprometerme a un proceso largo en el primer uso.

## Acceptance Criteria

1. Los pasos de personalización (Bautizo de mascota, Género, etc.) deben incluir un botón de "Omitir por ahora".
2. El sistema debe permitir el acceso al Hábitat de Milo inmediatamente después de aceptar los términos legales y configurar la seguridad, incluso si se omiten otros pasos.
3. El estado de "Onboarding Incompleto" debe persistirse localmente en la base de datos Isar.
4. Si el onboarding está incompleto, la app debe mostrar un recordatorio visual sutil en el Hábitat para completar la personalización.
## Tasks / Subtasks

- [x] Definir el esquema de Estado de Usuario en `isar_database` (AC: #3)
  - [x] Crear la colección `UserSettings` con campos `isOnboardingComplete` (bool) y `pendingSteps` (List<String>)
- [x] Implementar la lógica de "Omitir" en el flujo de Onboarding (AC: #1, #2)
  - [x] Crear un `OnboardingBloc` para gestionar la secuencia de pasos y el estado de compleción.
  - [x] Implementar el evento `SkipStep` que marque el paso como pendiente y avance al siguiente.
- [x] Desarrollar el recordatorio visual en el Hábitat (AC: #4)
  - [x] Crear un componente `PendingTasksBadge` que se muestre si `isOnboardingComplete` es falso.
- [x] Integrar validación de pasos obligatorios (AC: #5)
  - [x] Asegurar que el botón "Omitir" no esté presente en las vistas `LegalOnboardingPage` y `SecuritySetupPage`.
- [x] Implementar la transición final al Dashboard (AC: #2)
  - [x] Actualizar el router para navegar a `HabitatPage` cuando el usuario decida omitir o completar el onboarding.

## Dev Notes

- **Persistencia:** Se utiliza la colección `UserSettings` en Isar para persistir el estado de la personalización.
- **UI/UX:** Se implementó un `PendingTasksBadge` naranja en el AppBar del Hábitat como recordatorio sutil.
- **Navegación:** El flujo es: Legal -> Seguridad -> (Personalización | Hábitat).

## Dev Agent Record

### Agent Model Used
Gemini 2.0 Flash

### Debug Log References
- Generated `user_settings.g.dart` using build_runner.
- Updated `AppView` to include `MultiBlocProvider` and `MultiRepositoryProvider`.
- Verified `OnboardingBloc` handles both skip and completion events.

### Completion Notes List
- Flexible onboarding implemented with persistent state.
- Mandatory legal and security steps enforced.
- Visual badge for pending tasks verified in HabitatPage.

### File List
- packages/isar_database/lib/src/models/user_settings.dart
- packages/isar_database/lib/isar_database.dart
- lib/app/data/repositories/user_settings_repository.dart
- lib/app/logic/onboarding/onboarding_bloc.dart
- lib/app/logic/onboarding/onboarding_event.dart
- lib/app/logic/onboarding/onboarding_state.dart
- lib/app/view/habitat/habitat_page.dart
- lib/app/view/app.dart
- lib/bootstrap.dart
- main_development.dart, main_staging.dart, main_production.dart
- test/app/view/app_test.dart

Status: done
