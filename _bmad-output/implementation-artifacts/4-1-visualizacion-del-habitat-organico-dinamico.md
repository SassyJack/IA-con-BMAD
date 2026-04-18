# Story 4.1: Visualización del Hábitat Orgánico Dinámico

Status: done

## Story

Como **usuario**,
quiero **ver un entorno natural (fondos, degradados) que cambie según la hora del día y mis niveles de actividad detectados**,
para **sentir un acompañamiento visual relajante y coherente con mi estado actual**.

## Acceptance Criteria

1. Implementar el renderizado del Hábitat a 60 FPS estables (NFR2).
2. Utilizar la paleta "Refugio Visual" (Azul Cielo, Verde Menta, Lavanda, Crema).
3. El fondo debe ser dinámico, variando gradientes según la hora (mañana, tarde, noche).
4. El entorno debe reaccionar visualmente a los niveles de actividad (e.g., intensidad de partículas o brillo).
5. Asegurar radios de borde de 24px+ para una estética orgánica (UX-DR2).

## Tasks / Subtasks

- [x] **UI: Componente HabitatBackground** (AC: #1, #2, #3, #5)
  - [x] Crear un widget personalizado que maneje gradientes dinámicos basados en `DateTime`.
  - [x] Implementar transiciones suaves entre estados del día usando `AnimatedContainer`.
- [x] **UI: Decoración Orgánica** (AC: #4, #5)
  - [x] Añadir elementos visuales sutiles (`CustomPaint`) que reaccionen a la actividad física reciente.
  - [x] Aplicar estilos de bordes redondeados (32px) en contenedores principales de la página.
- [x] **Integración de Datos** (AC: #4)
  - [x] Crear `HabitatCubit` para conectar los eventos de `SensorRepository` con la UI.
  - [x] Ajustar el `activityLevel` dinámicamente según eventos de sensores.
- [x] **Pruebas y Optimización**
  - [x] Asegurar uso de widgets eficientes para mantener 60 FPS.
  - [x] Verificación visual de gradientes y paleta "Refugio Visual".

## Dev Notes

- **Rendimiento:** Evitar Rebuilds innecesarios. Usar `RepaintBoundary` si es necesario para elementos animados.
- **Estética:** Seguir las guías de diseño de "Refugio Visual" para mantener la calma.

### Project Structure Notes

- Widgets en `serenti/lib/app/view/habitat/widgets/`.
- Lógica de estilos en `serenti/lib/app/view/theme/`.

### References

- [Source: _bmad-output/planning-artifacts/prd.md#UX Design Requirements] (UX-DR1, UX-DR2, UX-DR3)
- [Source: _bmad-output/planning-artifacts/epics.md#Story 4.1: Visualización del Hábitat Orgánico Dinámico]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
