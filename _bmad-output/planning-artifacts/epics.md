---
stepsCompleted: [1, 2, 3]
inputDocuments:
  - '_bmad-output/planning-artifacts/prd.md'
  - '_bmad-output/planning-artifacts/architecture.md'
  - '_bmad-output/planning-artifacts/ux-design-specification.md'
---

# Serenti - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for Serenti, decomposing the requirements from the PRD, UX Design if it exists, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: El usuario puede completar un test PHQ-9 inicial y re-calibraciones semestrales.
FR2: El sistema establece una línea base de salud mental tras un periodo de gracia de 7 días.
FR3: El usuario puede bautizar a la mascota e ingresar su nombre y género (u opción neutra) para diálogos personalizados.
FR4: El sistema recolecta automáticamente metadatos de ubicación, actividad física y socialización de forma cifrada.
FR5: El sistema ejecuta el modelo MLP localmente cada 6 horas para actualizar el estado de la mascota.
FR6: El usuario puede configurar la frecuencia de las notificaciones locales (Intensidad de acompañamiento).
FR7: El sistema activa un acceso persistente a "Ayuda Inmediata" en estados de riesgo alto.
FR8: El usuario puede proteger la app mediante PIN o biometría con bloqueo automático tras 1 minuto de inactividad.
FR9: El sistema permite posponer partes del onboarding (excepto legal) para un acceso rápido a la mascota.

### NonFunctional Requirements

NFR1: La inferencia del MLP debe completar en < 100ms sin bloquear la interfaz.
NFR2: Las animaciones de la mascota deben renderizarse a un mínimo de 60 FPS estables.
NFR3: El sistema debe operar al 100% de su capacidad sin conexión a internet.
NFR4: El diseño debe cumplir con WCAG 2.1 nivel AA para accesibilidad.
NFR5: El instalador de la app debe pesar menos de 50MB para el MVP.

### Additional Requirements

- **Starter Template:** Uso de **Very Good CLI** (Flutter).
- **Patrón Arquitectónico:** BLoC (flutter_bloc).
- **Base de Datos:** Isar Community v3.3.1 con cifrado AES-256.
- **Seguridad:** PIN + Biometría mediante `flutter_secure_storage` v10.0.0 (Keystore/Keychain).
- **Edge AI:** `tflite_flutter` v0.12.1 con modelo MLP cuantizado en un Isolate dedicado.
- **Estructura:** Modularizada en `/packages` (isar_database, tflite_service, security_vault, sensor_kit).
- **Infraestructura:** Offline-first, CI/CD con GitHub Actions/Codemagic.

### UX Design Requirements

UX-DR1: Implementar paleta "Refugio Visual" (Azul Cielo, Verde Menta, Lavanda, Crema).
UX-DR2: Configurar fuente Nunito y radios de borde de 24px+ para estética orgánica.
UX-DR3: Implementar Hábitat Orgánico con fondo dinámico reactivo a sensores.
UX-DR4: Desarrollar la Mascota Milo con estados Idle, Joy, Rest y Shelter.
UX-DR5: Implementar flujo de "Vistazo de Validación" (carga en < 2 segundos).
UX-DR6: Diseñar Dashboard de Crisis Offline accesible desde botón persistente en riesgo alto.
UX-DR7: Implementar Modo Oscuro "Noche de Calma" para higiene del sueño.
UX-DR8: Implementar Sliders Empáticos para tests PHQ-9 (reacción de mascota en tiempo real).

### FR Coverage Map

FR1: Épica 2 - Test PHQ-9 inicial.
FR2: Épica 3 - Línea base tras 7 días.
FR3: Épica 2 - Personalización de mascota.
FR4: Épica 3 - Recolección pasiva cifrada.
FR5: Épica 3 - Ejecución MLP local.
FR6: Épica 4 - Configuración de notificaciones.
FR7: Épica 5 - Acceso a "Ayuda Inmediata".
FR8: Épica 1 - Protección por PIN/Biometría.
FR9: Épica 1 - Onboarding legal obligatorio.

## Epic List

### Epic 1: Seguridad y Onboarding Legal
El usuario puede acceder a la app de forma segura y otorgar su consentimiento legal, estableciendo la base de privacidad.
**FRs covered:** FR8, FR9.
**NFRs covered:** NFR3.

#### Stories
- **Story 1.0: Inicialización del Proyecto con Very Good CLI**
  - Como desarrollador, quiero generar la estructura base del proyecto usando Very Good CLI para asegurar una arquitectura modular y escalable desde el inicio.
  - **Acceptance Criteria:** Generación exitosa con `very_good create`, configuración de paquetes modulares en `/packages` (isar_database, tflite_service, etc.).
- **Story 1.1: Consentimiento Informado y Setup de Persistencia (Ley 1581)**
  - Como usuario, quiero aceptar los términos legales y que el sistema inicialice mi bóveda de datos cifrada localmente.
  - **Acceptance Criteria:** Bloqueo de acceso hasta aceptación, inicialización de Isar Database con cifrado AES-256 activo, persistencia offline del estado de aceptación.
- **Story 1.2: Configuración de Seguridad Personalizada**
  - Como usuario, quiero configurar un PIN o biometría para proteger el acceso a mi información de salud mental.
  - **Acceptance Criteria:** Integración con `flutter_secure_storage` y `local_auth`.
- **Story 1.3: Bloqueo Automático de Sesión**
  - Como usuario, quiero que la app se bloquee tras 1 minuto de inactividad para evitar accesos no autorizados si dejo mi teléfono desbloqueado.
  - **Acceptance Criteria:** Temporizador de inactividad que activa la pantalla de PIN/Biometría.
- **Story 1.4: Onboarding Ágil y Flexible**
  - Como usuario, quiero poder saltar la personalización inicial para ver a mi mascota rápidamente, sabiendo que puedo completarla luego.
  - **Acceptance Criteria:** Botón "Omitir por ahora" en pasos no legales, persistencia de estado pendiente.

### Epic 2: Configuración de la Mascota y Primeros Pasos
El usuario personaliza a su compañero y completa la calibración inicial de salud mental.
**FRs covered:** FR1, FR3.
**UX-DR covered:** UX-DR4, UX-DR8.

#### Stories
- **Story 2.1: Bautizo y Personalización de Milo**
  - Como usuario, quiero asignar un nombre y género (incluyendo opción neutra) a mi mascota para crear un vínculo emocional.
  - **Acceptance Criteria:** Formulario de personalización, diálogos de Milo actualizados con los datos ingresados.
- **Story 2.2: Test PHQ-9 Inicial con Sliders Empáticos**
  - Como usuario, quiero completar mi primer test de salud mental usando una interfaz amable donde Milo reaccione a mis respuestas.
  - **Acceptance Criteria:** Implementación de sliders que cambian la expresión de Milo en tiempo real, guardado cifrado del resultado.
- **Story 2.3: Bienvenida y Primer Diálogo**
  - Como usuario, quiero que Milo se presente y me explique brevemente cómo me acompañará.
  - **Acceptance Criteria:** Secuencia de diálogos iniciales tras la personalización.

### Epic 3: Inteligencia Silenciosa (Sensores e IA)
El sistema recolecta datos pasivamente y ejecuta el modelo de IA local para actualizar la mascota.
**FRs covered:** FR4, FR5.
**NFRs covered:** NFR1.

#### Stories
- **Story 3.1: Recolección Pasiva y Sigilosa de Metadatos**
  - Como sistema, debo recolectar datos de movilidad, actividad y socialización en segundo plano sin agotar la batería (<5% diario).
  - **Acceptance Criteria:** Uso de `geolocator`, `pedometer` y metadatos de comunicación (sin contenido).
- **Story 3.2: Inferencia Local MLP (Edge AI)**
  - Como sistema, debo ejecutar el modelo TFLite cada 6 horas en un Isolate dedicado para actualizar el estado emocional de Milo.
  - **Acceptance Criteria:** Tiempo de ejecución <100ms, actualización silenciosa de la base de datos de estado.
- **Story 3.3: Calibración de Línea Base (Periodo de Gracia)**
  - Como sistema, debo recolectar datos durante 7 días antes de establecer una línea base definitiva para evitar falsas alertas iniciales.
  - **Acceptance Criteria:** Lógica de "Periodo de Gracia" en el motor de IA, feedback visual de "Conociéndote" en la app.

### Epic 4: El Hábitat Orgánico y Acompañamiento Diario
El usuario visualiza el estado emocional de su mascota en un entorno dinámico basado en su actividad.
**FRs covered:** FR2, FR6.
**UX-DR covered:** UX-DR1, UX-DR2, UX-DR3, UX-DR4, UX-DR7.

#### Stories
- **Story 4.1: Visualización del Hábitat Orgánico Dinámico**
  - Como usuario, quiero ver un entorno natural (fondos, degradados) que cambie según la hora del día y mis niveles de actividad detectados.
  - **Acceptance Criteria:** Renderizado a 60 FPS (NFR2), uso de paleta "Refugio Visual".
- **Story 4.2: Estados de Ánimo de Milo (Reflejo Emocional)**
  - Como usuario, quiero que Milo muestre estados de Idle, Joy, Rest o Shelter para entender mi bienestar de un vistazo.
  - **Acceptance Criteria:** Animaciones específicas para cada estado, lógica de transición basada en la salida del MLP.
- **Story 4.3: Gestión de Notificaciones (Intensidad de Acompañamiento)**
  - Como usuario, quiero ajustar qué tan seguido Milo me envía mensajes para que no se sienta intrusivo.
  - **Acceptance Criteria:** Slider de configuración de frecuencia, programación de notificaciones locales.
- **Story 4.4: Modo Oscuro "Noche de Calma"**
  - Como usuario, quiero que la app use tonos azules medianoche y ámbar de noche para no afectar mi higiene del sueño.
  - **Acceptance Criteria:** Cambio automático de tema basado en horario o sistema, Milo en estado "Rest".

### Epic 5: Soporte en Crisis y Prevención
El usuario recibe apoyo inmediato y recursos cuando se detecta un riesgo elevado.
**FRs covered:** FR7.
**UX-DR covered:** UX-DR6.

#### Stories
- **Story 5.1: Activación de Alerta de Riesgo**
  - Como usuario, quiero que Milo cambie a un estado de alerta empática y el entorno cambie sutilmente si se detecta un riesgo alto de depresión.
  - **Acceptance Criteria:** Cambio visual del hábitat, notificación local prioritaria.
- **Story 5.2: Botón de Ayuda Inmediata Persistente**
  - Como usuario en crisis, quiero tener un acceso rápido y visible a recursos de ayuda en todo momento cuando mi riesgo es elevado.
  - **Acceptance Criteria:** Botón "Ancla" prominente en el dashboard principal bajo estados de riesgo.
- **Story 5.3: Dashboard de Crisis Offline**
  - Como usuario, quiero acceder a líneas de emergencia, guías de respiración y consejos de autocuidado sin necesidad de internet.
  - **Acceptance Criteria:** Contenido estático precargado, llamadas directas a líneas de emergencia desde la app.

<!-- Content will be appended in subsequent steps -->
