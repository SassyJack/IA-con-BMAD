# Story 5.3: Dashboard de Crisis Offline

Status: done

## Story

Como **usuario**,
quiero **acceder a líneas de emergencia, guías de respiración y consejos de autocuidado sin necesidad de internet**,
para **tener un soporte confiable incluso en situaciones de baja conectividad**.

## Acceptance Criteria

1. El Dashboard de Crisis debe ser accesible desde el `CrisisActionButton` (implementado en Story 5.2).
2. Debe contener secciones claras:
   - **Líneas de Ayuda:** Botones para llamar directamente a líneas de emergencia (ej. 123 en Colombia, o líneas específicas de salud mental).
   - **Guía de Respiración:** Una animación o guía visual simple (ej. técnica 4-7-8) para calmar la ansiedad.
   - **Consejos de Autocuidado:** Lista de 3-5 consejos accionables y breves.
3. Todo el contenido debe ser estático y precargado (Offline-first).
4. La interfaz debe seguir la paleta de alerta suave (ámbar/lavanda) para mantener la coherencia con el estado de riesgo.
5. El sistema debe solicitar permisos de llamada si es necesario al intentar marcar.

## Tasks / Subtasks

- [x] **Infrastructure: url_launcher**
  - [x] Añadir `url_launcher` a `pubspec.yaml`.
  - [x] Configurar los `queries` necesarios en AndroidManifest e Info.plist para llamadas telefónicas.
- [x] **UI: Dashboard de Crisis**
  - [x] Crear `serenti/lib/app/view/crisis/crisis_page.dart`.
  - [x] Implementar la sección de "Líneas de Ayuda".
  - [x] Implementar el "Ejercicio de Respiración" (Animación simple).
  - [x] Implementar la sección de "Tips de Autocuidado".
- [x] **Navigation: Integración**
  - [x] Conectar el `CrisisActionButton` con la navegación a `CrisisPage`.

## Dev Agent Record

### Agent Model Used

Gemini 2.0 Flash Thinking

### Debug Log References

### Completion Notes List

### File List
