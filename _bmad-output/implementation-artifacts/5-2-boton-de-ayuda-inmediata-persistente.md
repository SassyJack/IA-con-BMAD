# Story 5.2: Botón de Ayuda Inmediata Persistente

Status: done

## Story

Como **usuario en crisis**,
quiero **tener un acceso rápido y visible a recursos de ayuda en todo momento cuando mi riesgo es elevado**,
para **poder actuar rápidamente y buscar apoyo sin fricciones**.

## Acceptance Criteria

1. El botón de "Ayuda Inmediata" (Ancla) solo debe ser visible si `isHighRisk` es verdadero en el `HabitatState`.
2. El botón debe ser visualmente prominente, usando la paleta de alerta (ámbar/lavanda) para destacar pero manteniendo una estética de calma.
3. El botón debe estar ubicado en una posición persistente y de fácil acceso (ej. Bottom Right Floating Action Button).
4. Al presionar el botón, debe navegar al "Dashboard de Crisis" (que será implementado en la Story 5.3). Por ahora, puede mostrar un diálogo de confirmación o un placeholder.
5. El botón debe desaparecer automáticamente si el estado de riesgo baja de "Alto".

## Tasks / Subtasks

- [x] **UI: Botón de Ayuda**
  - [x] Crear el widget `CrisisActionButton` (Floating Action Button personalizado).
  - [x] Integrar el botón en `HabitatPage` usando un `BlocBuilder` para controlar su visibilidad.
- [x] **Logic: Navegación**
  - [x] Definir la ruta para el Dashboard de Crisis.
  - [x] Implementar la acción de navegación al presionar el botón.
- [x] **UX: Animación de Aparición**
  - [x] Añadir una animación suave (Fade/Scale) para la aparición y desaparición del botón.

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
