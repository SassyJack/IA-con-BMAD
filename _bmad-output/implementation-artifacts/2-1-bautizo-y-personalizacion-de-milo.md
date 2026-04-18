# Story 2.1: Bautizo y Personalización de Milo

Status: done

## Story

Como usuario,
quiero asignar un nombre y género (incluyendo opción neutra) a mi mascota,
para crear un vínculo emocional con mi compañero digital.

## Acceptance Criteria

1. **Formulario de Personalización:** El usuario debe poder ingresar un nombre para la mascota y seleccionar un género (Masculino, Femenino, Neutro). [Source: _bmad-output/planning-artifacts/epics.md#Story 2.1]
2. **Validación de Datos:** El nombre debe tener al menos 2 caracteres y no superar los 20. El género es obligatorio.
3. **Persistencia Cifrada:** Los datos de la mascota deben guardarse en la base de datos Isar de forma cifrada (AES-256). [Source: _bmad-output/planning-artifacts/prd.md#Phase 1]
4. **Actualización de Diálogos:** Los diálogos de la mascota deben utilizar el nombre y género seleccionados inmediatamente después de la personalización. [Source: _bmad-output/planning-artifacts/epics.md#Story 2.1]
5. **Estado de Onboarding:** Al completar este paso, el estado de onboarding debe actualizarse para reflejar que la personalización inicial se ha realizado. [Source: _bmad-output/planning-artifacts/epics.md#Story 1.4]

## Tasks / Subtasks

- [x] **Data Model Extension (AC: 3)**
  - [x] Crear el modelo `PetProfile` en `serenti/packages/isar_database/lib/src/models/pet_profile.dart`.
  - [x] Registrar `PetProfileSchema` en `serenti/packages/isar_database/lib/src/isar_database.dart`.
  - [x] Actualizar `UserSettings` en `serenti/packages/isar_database/lib/src/models/user_settings.dart` para incluir un flag de `petCustomized`.
  - [x] Ejecutar `build_runner` para generar el código de Isar.
- [x] **Business Logic (BLoC) (AC: 1, 4, 5)**
  - [x] Crear `PetBloc` en `serenti/lib/app/pet/bloc/pet_bloc.dart` para gestionar la personalización.
  - [x] Implementar eventos `PetNameChanged`, `PetGenderChanged`, `PetProfileSubmitted`.
  - [x] Integrar con la instancia de `IsarDatabase` de `packages/isar_database`.
- [x] **UI Implementation (AC: 1, 2)**
  - [x] Crear `PetCustomizationPage` en `serenti/lib/app/pet/view/pet_customization_page.dart`.
  - [x] Implementar campos de texto con validación y selector de género (RadioButtons o ChoiceChips: Masculino, Femenino, Neutro).
  - [x] Aplicar estilo visual: Nunito font, 24px+ border radius, paleta "Refugio Visual". [Source: _bmad-output/planning-artifacts/ux-design-specification.md]
- [x] **Verification & Testing (AC: 1-5)**
  - [x] Crear tests unitarios para `PetBloc`.
  - [x] Crear tests de widget para `PetCustomizationPage`.
  - [x] Verificar la persistencia en Isar mediante un test de integración o mock.

## Dev Notes

- **Architecture:** Seguir el patrón BLoC (flutter_bloc) y la estructura modular en `/packages`.
- **Database:** Isar Community v3.3.1 con cifrado AES-256 (ya configurado en `IsarDatabase`).
- **Styling:** Usar `Nunito` como fuente principal y radios de borde de 24px+ para una estética orgánica.
- **L10n:** Asegurar que todos los textos estén en `arb` files en `serenti/lib/l10n/`.

### Project Structure Notes

- Los modelos de base de datos residen en `serenti/packages/isar_database/lib/src/models/`.
- La lógica de la aplicación reside en `serenti/lib/app/`.

### References

- [Source: _bmad-output/planning-artifacts/prd.md#Functional Requirements]
- [Source: _bmad-output/planning-artifacts/ux-design-specification.md#Base del Sistema de Diseño]
- [Source: _bmad-output/planning-artifacts/epics.md#Epic 2]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash

### Debug Log References

### Completion Notes List

### File List
