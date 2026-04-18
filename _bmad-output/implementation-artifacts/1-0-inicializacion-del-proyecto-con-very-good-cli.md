# Story 1.0: Inicialización del Proyecto con Very Good CLI

Status: review

## Story

As a Desarrollador,
I want generar la estructura base del proyecto usando Very Good CLI,
so that asegurar una arquitectura modular y escalable desde el inicio.

## Acceptance Criteria

1. Generación exitosa de la aplicación Flutter base utilizando el comando `very_good create flutter_app`.
2. Configuración de la estructura de monorepositorio con una carpeta `/packages` para módulos independientes.
3. Creación de los paquetes base en `/packages`: `isar_database`, `tflite_service`, `security_vault` y `sensor_kit`.
4. Configuración del sistema de análisis de código `very_good_analysis`.
5. Verificación de que el proyecto base compile y ejecute los tests iniciales con 100% de cobertura (según estándar de VGV).

## Tasks / Subtasks

- [x] Instalar y configurar el entorno de desarrollo (AC: #1)
  - [x] Activar `very_good_cli`: `dart pub global activate very_good_cli`
- [x] Generar la aplicación principal (AC: #1, #4)
  - [x] Ejecutar `very_good create flutter_app serenti --org com.ramon.serenti --description "Serenti: Salud Mental y Acompañamiento Empático"`
  - [x] Validar la configuración de `analysis_options.yaml`
- [x] Configurar la estructura modular (AC: #2, #3)
  - [x] Crear el directorio raíz `/packages` si no existe
  - [x] Generar el paquete `isar_database` (Dart package): `very_good create dart_package isar_database`
  - [x] Generar el paquete `tflite_service` (Dart package): `very_good create dart_package tflite_service`
  - [x] Generar el paquete `security_vault` (Dart package): `very_good create dart_package security_vault`
  - [x] Generar el paquete `sensor_kit` (Dart package): `very_good create dart_package sensor_kit`
- [x] Configurar dependencias iniciales (AC: #3)
  - [x] Agregar `flutter_bloc` y `equatable` al proyecto principal
  - [x] Configurar las dependencias locales en el `pubspec.yaml` de la app principal para apuntar a los paquetes en `/packages`
- [x] Validación final (AC: #5)
  - [x] Ejecutar `very_good test --recursive` para asegurar integridad inicial

## Dev Notes

- **Patrón Arquitectónico:** Se debe seguir estrictamente el patrón **BLoC** para la gestión de estado.
- **Arquitectura por Capas:** Cada feature debe estar organizada por carpetas (Data, Domain, Presentation).
- **Repository Pattern:** Los paquetes en `/packages` deben exponer Repositorios abstractos para facilitar el testing y el desacoplamiento.
- **Estándar de Testing:** Mantener el objetivo de **100% de cobertura** en todos los nuevos componentes.
- **Offline-first:** El setup inicial debe contemplar que la aplicación funcionará sin conexión, priorizando la persistencia local.

### Project Structure Notes

- **Monorepo:** Aunque se usa `/packages`, se debe considerar el uso de una herramienta como Melos en el futuro si la complejidad aumenta, pero para el MVP la estructura de `/packages` nativa es suficiente.
- **Naming Conventions:** Seguir `snake_case` para archivos y carpetas, y `PascalCase` para clases.

### References

- [Source: architecture.md#Starter Template] - Uso obligatorio de Very Good CLI.
- [Source: architecture.md#Estructura] - Modularización en `/packages`.
- [Source: prd.md#Phase 1: MVP] - Requerimientos técnicos base.
- [Source: epics.md#Story 1.0] - Definición de la historia de inicialización.

## Dev Agent Record

### Agent Model Used
Gemini 2.0 Flash

### Debug Log References
- PATH issues resolved by absolute paths to Flutter/Dart SDK.
- pubspec.yaml syntax error (unquoted colon in description) corrected.
- Code Review findings addressed: Added missing base dependencies to modular packages, standardized SDK constraints, and updated READMEs.

### Completion Notes List
- Successful project generation using very_good_cli.
- Modular packages created in /packages with full technical setup (isar, tflite, security, sensors).
- All initial tests and dependency resolutions passing.

### File List
- /serenti/**
- /serenti/packages/isar_database/** (Updated deps & README)
- /serenti/packages/tflite_service/** (Updated deps & README)
- /serenti/packages/security_vault/** (Updated deps & README)
- /serenti/packages/sensor_kit/** (Updated deps & README)

Status: done
