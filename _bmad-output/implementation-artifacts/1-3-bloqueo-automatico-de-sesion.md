# Story 1.3: Bloqueo Automático de Sesión

Status: ready-for-dev

## Story

As a Usuario,
I want que la app se bloquee tras 1 minuto de inactividad,
so that evitar accesos no autorizados si dejo mi teléfono desbloqueado y desatendido.

## Acceptance Criteria

1. El sistema debe detectar la inactividad del usuario (sin toques en pantalla) en toda la aplicación.
2. Tras 1 minuto exacto de inactividad, la aplicación debe mostrar automáticamente la pantalla de bloqueo (`LockScreen`).
3. El temporizador de inactividad debe reiniciarse con cualquier interacción táctil del usuario.
4. Si la app está en segundo plano, el temporizador debe pausarse y reiniciarse al regresar (resumed), o bloquearse inmediatamente si ya pasó el tiempo.
## Tasks / Subtasks

- [x] Implementar el temporizador de inactividad global (AC: #1, #3)
  - [x] Envolver `MaterialApp` en un `Listener` o `GestureDetector` para capturar interacciones globales.
  - [x] Crear una clase `InactivityTimer` o similar que maneje el `Timer` de 60 segundos.
- [x] Integrar con `SecurityBloc` (AC: #2)
  - [x] Añadir evento `SecurityLockSession` al `SecurityBloc`.
  - [x] Disparar el evento cuando el temporizador expire.
- [x] Manejar estados de ciclo de vida (AC: #4)
  - [x] Asegurar que el temporizador se gestione correctamente cuando la app cambia entre `foreground` y `background`.
- [x] Validar pantallas excluidas (AC: #5)
  - [x] Evitar que el temporizador dispare el bloqueo si el estado actual ya es `unauthenticated` o `setupRequired`.

## Dev Notes

- **Rendimiento:** El uso de un `Listener` global es eficiente.
- **Timer:** Se utilizó `dart:async` para gestionar el temporizador de 1 minuto.
- **Integración:** El bloqueo se dispara mediante el BLoC, lo que asegura que la UI reaccione correctamente.

## Dev Agent Record

### Agent Model Used
Gemini 2.0 Flash

### Debug Log References
- Fixed `AppView` structure to handle both `WidgetsBindingObserver` and global `Listener`.
- Verified timer cancellation during `dispose` and `paused` state.

### Completion Notes List
- Global inactivity detection implemented and verified.
- Automatic session locking after 1 minute functional.
- Tests passing 100%.

### File List
- lib/app/logic/security/security_bloc.dart
- lib/app/logic/security/security_event.dart
- lib/app/view/app.dart
- test/app/view/app_test.dart

Status: done
