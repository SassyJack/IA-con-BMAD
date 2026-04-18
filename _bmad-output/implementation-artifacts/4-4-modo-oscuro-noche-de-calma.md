# Story 4.4: Modo Oscuro "Noche de Calma"

Status: done

## Story

Como **usuario**,
quiero **que la app use tonos oscuros y cálidos durante la noche**,
para **proteger mi higiene del sueño y reducir la fatiga visual**.

## Acceptance Criteria

1. Implementar una paleta de colores para el Modo Oscuro ("Noche de Calma") usando azules medianoche y ámbar.
2. El cambio de tema debe ser automático basándose en el horario (e.g., después de las 22:00) o seguir la configuración del sistema.
3. Durante el Modo Oscuro, Milo debe mostrar preferiblemente el estado "Rest" (descanso).
4. El Hábitat debe oscurecerse sutilmente manteniendo la legibilidad (NFR4).

## Tasks / Subtasks

- [x] **UI: Definición del Tema Oscuro** (AC: #1)
  - [x] Añadir colores de "Noche de Calma" (Ámbar Calma, Indigo 900) a `SerentiColors`.
  - [x] Configurar `SerentiColors.darkTheme` y `SerentiColors.lightTheme`.
- [x] **Logic: ThemeCubit** (AC: #2)
  - [x] Crear `ThemeCubit` para manejar el cambio automático entre Light/Dark.
  - [x] Implementar un `Timer.periodic` que verifica la hora cada minuto.
- [x] **UI: Adaptación de Widgets** (AC: #3, #4)
  - [x] Actualizar `HabitatBackground` para usar gradientes profundos en horario nocturno.
  - [x] Configurar `MaterialApp` para reaccionar al estado del `ThemeCubit`.
- [x] **Pruebas**
  - [x] Verificación de contraste AA en temas claro y oscuro.

## Dev Notes

- **Higiene del Sueño:** El uso de ámbar ayuda a reducir la luz azul.
- **Transición:** El cambio debe ser suave, idealmente detectado al abrir la app o mediante un watcher.

### Project Structure Notes

- Theme: `serenti/lib/app/view/theme/`
- Logic: `serenti/lib/app/logic/theme/`

### References

- [Source: _bmad-output/planning-artifacts/prd.md#UX Design Requirements] (UX-DR7)
- [Source: _bmad-output/planning-artifacts/epics.md#Story 4.4: Modo Oscuro "Noche de Calma"]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
