# Story 4.2: Estados de Ánimo de Milo (Reflejo Emocional)

Status: done

## Story

Como **usuario**,
quiero **que Milo muestre estados de Idle, Joy, Rest o Shelter**,
para **entender mi bienestar de un vistazo a través de su lenguaje corporal y expresión**.

## Acceptance Criteria

1. Implementar representaciones visuales (iconos/animaciones) para los 4 estados:
   - **Idle:** Estado neutro/base.
   - **Joy:** Estado positivo/activo.
   - **Rest:** Estado de calma/sueño.
   - **Shelter:** Estado de protección/baja energía.
2. La transición entre estados debe ser fluida y basada en el último `MiloState` guardado en `isar_database`.
3. El widget de Milo debe mostrarse de forma prominente en el Hábitat.
4. Integrar con el `PetBloc` para reflejar el estado actual.

## Tasks / Subtasks

- [x] **Logic: Actualización de PetState** (AC: #4)
  - [x] Añadir campo `currentMood` a `serenti/lib/app/logic/pet/pet_state.dart`.
  - [x] Implementar evento `PetMoodUpdated` y `PetWatchMoodChanges` en `pet_event.dart`.
  - [x] Actualizar `PetBloc` para escuchar cambios en la colección `MiloState` de Isar.
- [x] **UI: Componente PetAvatar** (AC: #1, #2)
  - [x] Crear un widget `PetAvatar` que cambie de icono/color según el mood.
  - [x] Añadir animaciones de transición suaves usando `AnimatedSwitcher` y `ScaleTransition`.
- [x] **Integración en Hábitat** (AC: #3)
  - [x] Reemplazar el icono estático de `HabitatPage` con el nuevo `PetAvatar`.
- [x] **Pruebas**
  - [x] Adaptar `PetBloc` para manejar la nueva dependencia de `IsarDatabase`.

## Dev Notes

- **Assets:** Por ahora usaremos `Icons` de Material con diferentes colores/formas para representar los estados si no hay imágenes finales.
- **Rendimiento:** NFR2 (60 FPS) se aplica a las animaciones de Milo.

### Project Structure Notes

- Logic: `serenti/lib/app/logic/pet/`
- UI: `serenti/lib/app/view/pet/widgets/`

### References

- [Source: _bmad-output/planning-artifacts/prd.md#UX Design Requirements] (UX-DR4)
- [Source: _bmad-output/planning-artifacts/epics.md#Story 4.2: Estados de Ánimo de Milo]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
