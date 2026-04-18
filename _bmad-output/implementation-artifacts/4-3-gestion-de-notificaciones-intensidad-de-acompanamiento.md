# Story 4.3: Gestión de Notificaciones (Intensidad de Acompañamiento)

Status: done

## Story

Como **usuario**,
quiero **ajustar qué tan seguido Milo me envía mensajes**,
para **que no se sienta intrusivo y se adapte a mi necesidad de acompañamiento**.

## Acceptance Criteria

1. Implementar la persistencia de `notificationIntensity` en `isar_database`.
2. Crear una pantalla de configuración accesible desde el Hábitat.
3. Incluir un slider para ajustar la intensidad (Sutil, Equilibrado, Frecuente).
4. El sistema debe guardar el cambio inmediatamente tras mover el slider.

## Tasks / Subtasks

- [x] **Persistencia: UserSettings** (AC: #1)
  - [x] Añadir campo `notificationIntensity` a `UserSettings`.
  - [x] Ejecutar `build_runner` para actualizar esquemas Isar.
- [x] **Logic: SettingsCubit**
  - [x] Implementar `SettingsCubit` para manejar la carga y actualización de la intensidad.
  - [x] Integrar con `UserSettingsRepository`.
- [x] **UI: SettingsPage** (AC: #2, #3, #4)
  - [x] Crear `SettingsPage` con el slider de intensidad.
  - [x] Usar la paleta "Refugio Visual".
- [x] **Navegación**
  - [x] Añadir botón de ajustes en el `AppBar` del Hábitat.

## Dev Notes

- **Frecuencia:** Aunque aún no hay un motor de notificaciones activo, la persistencia está lista para ser consumida por el futuro `NotificationService`.
- **UX:** El slider tiene 4 divisiones para permitir granularidad en el acompañamiento.

### Project Structure Notes

- Logic: `serenti/lib/app/logic/settings/`
- View: `serenti/lib/app/view/settings/`

### References

- [Source: _bmad-output/planning-artifacts/prd.md#Functional Requirements] (FR6)
- [Source: _bmad-output/planning-artifacts/epics.md#Story 4.3: Gestión de Notificaciones]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
