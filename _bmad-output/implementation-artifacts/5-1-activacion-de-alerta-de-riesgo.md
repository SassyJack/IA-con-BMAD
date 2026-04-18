# Story 5.1: Activación de Alerta de Riesgo

Status: done

## Story

Como **usuario**,
quiero **que Milo cambie a un estado de alerta empática y el entorno cambie sutilmente si se detecta un riesgo alto**,
para **sentirme acompañado y ser consciente de que necesito autocuidado o ayuda externa**.

## Acceptance Criteria

1. Definir la lógica de "Riesgo Alto" basada en:
   - Resultados de la inferencia MLP (Estado `shelter` persistente o baja confianza).
   - Caída drástica (>50%) en movilidad o socialización comparado con la Línea Base.
2. El entorno del Hábitat debe cambiar a una paleta de "Alerta Suave" (tonos ámbar/lavanda profundos) para llamar la atención sin causar ansiedad.
3. Milo debe mostrar una animación de "Protección/Alerta" (estado `shelter` reforzado).
4. El sistema debe preparar una notificación local prioritaria (AC de Story 5.2/5.3 dependerán de este trigger).

## Tasks / Subtasks

- [x] **Logic: Detección de Riesgo**
  - [x] Implementar `RiskCubit` para evaluar el estado de riesgo comparando datos actuales vs Línea Base en `UserSettings`.
  - [x] Integrar con `InferenceRepository` para recibir alertas del modelo.
- [x] **UI: Visualización de Alerta**
  - [x] Añadir estado `isRiskState` en `HabitatState`.
  - [x] Actualizar `HabitatBackground` para reaccionar al estado de riesgo.
  - [x] Asegurar que Milo refleje el estado `shelter` de forma prominente.
- [x] **Pruebas**
  - [x] Unit tests para la lógica de comparación vs Línea Base.

## Dev Notes

- **Sensibilidad:** La detección debe evitar "falsos positivos" mediante un sistema de promedio móvil.
- **Estética:** El cambio visual debe ser orgánico y "preocupado", no alarmista.

### Project Structure Notes

- Logic: `serenti/lib/app/logic/risk/`
- View: Adaptaciones en `serenti/lib/app/view/habitat/`

### References

- [Source: _bmad-output/planning-artifacts/prd.md#Functional Requirements] (FR7)
- [Source: _bmad-output/planning-artifacts/epics.md#Story 5.1: Activación de Alerta de Riesgo]

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Assigned Agents

- Amelia (Developer)
- Winston (Architect)

### Debug Log References

### Completion Notes List

- Implementada lógica de RiskCubit con éxito.
- El cambio visual ámbar funciona correctamente.

### File List
