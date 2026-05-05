# Informe Técnico del Proyecto: Serenti

Este documento consolida la información técnica, de diseño e implementación del proyecto **Serenti**, una aplicación móvil de salud mental basada en fenotipado digital y Edge AI.

---

## 1. Elección del Dataset y Herramientas Tecnológicas

### Dataset: StudentLife (Dartmouth College)
El cerebro de Serenti se fundamenta en el dataset **StudentLife**, el primer estudio a gran escala que correlaciona datos de sensores de smartphones con la salud mental en estudiantes universitarios.
*   **Motivación:** Alineación directa con el público objetivo de la aplicación.
*   **Etiquetas:** Utiliza resultados del cuestionario clínico PHQ-9 para clasificar niveles de riesgo depresivo.

### Herramientas Tecnológicas e IDE
*   **IDE Principal:** IntelliJ IDEA / VS Code (con soporte para Flutter/Dart).
*   **Framework:** **Flutter** (usando Very Good CLI para una estructura robusta y escalable).
*   **Lenguajes de Programación:** 
    *   **Dart:** Desarrollo de la aplicación móvil y lógica de negocio.
    *   **Python:** Entrenamiento, validación y conversión del modelo de IA.
*   **Motor de IA:** **TensorFlow Lite (TFLite)** para inferencia local en tiempo real.
*   **Base de Datos:** **Isar Database**, motor NoSQL local con cifrado nativo.
*   **Seguridad:** Flutter Secure Storage para gestión de llaves y biometría integrada.

---

## 2. Requisitos

### Requisitos Funcionales (FR)
*   **FR1 (Evaluación Clínica):** Realización de test PHQ-9 inicial y recalibraciones periódicas.
*   **FR2 (Línea Base):** Establecimiento de un comportamiento "normal" del usuario tras 7 días de observación.
*   **FR3 (Personalización):** Bautizo y personalización de la mascota digital "Milo".
*   **FR4 (Recolección Pasiva):** Captura cifrada de metadatos de movilidad, actividad física y socialización.
*   **FR5 (Inferencia Local):** Ejecución del modelo MLP cada 6 horas sin salida de datos a la nube.
*   **FR6 (Notificaciones):** Gestión de la intensidad de acompañamiento mediante notificaciones locales.
*   **FR7 (Gestión de Crisis):** Acceso persistente a recursos de ayuda inmediata en estados de alto riesgo.
*   **FR8 (Seguridad de Acceso):** Bloqueo automático de sesión y protección mediante PIN/Biometría.

### Requisitos No Funcionales (NFR)
*   **NFR1 (Rendimiento):** Inferencia del modelo MLP en menos de 100ms.
*   **NFR2 (Fluidez):** Interfaz renderizada a un mínimo de 60 FPS estables.
*   **NFR3 (Autonomía):** Operación 100% offline (Zero-Cloud Policy).
*   **NFR4 (Accesibilidad):** Cumplimiento de estándares WCAG 2.1 nivel AA.
*   **NFR5 (Ligereza):** Tamaño del instalador inferior a 50MB para el MVP.

---

## 3. Análisis y Diseño

### Arquitectura de Software (Modular)
El sistema se divide en paquetes desacoplados para garantizar mantenibilidad y facilitar el testing:
*   `sensor_kit`: Módulo de recolección de datos de sensores.
*   `tflite_service`: Abstracción de la carga e inferencia del modelo `.tflite`.
*   `isar_database`: Gestión de persistencia local cifrada (AES-256).
*   `security_vault`: Protección de datos bajo la Ley 1581 y gestión de claves.

### Cerebro AI: Perceptrón Multicapa (MLP)
Se diseñó un modelo **MLP v2.0 Robust** optimizado para dispositivos móviles:
*   **Arquitectura:** 4 capas (Entrada, 2 Ocultas con Dropout/BatchNormalization, Salida Softmax).
*   **Features:** Movilidad (GPS), Actividad (Acelerómetro), Sueño (Inactividad) y Sociabilidad (Bluetooth).
*   **Privacidad:** Diseño "Edge AI" donde la inferencia ocurre exclusivamente en el smartphone.

### Diseño de Experiencia (UX/UI)
La "humanización" de los datos se logra a través de **Milo**, una mascota digital cuyo estado emocional y entorno (Hábitat) reflejan los resultados de la IA:
*   **Riesgo Bajo:** Hábitat floreciente y mascota activa.
*   **Riesgo Alto:** Hábitat desaturado y activación de protocolos de emergencia.

---

## 4. Codificación (Implementación)

El proceso de desarrollo se ejecutó en fases incrementales:

1.  **Infraestructura Base:**
    *   Inicialización con Very Good CLI.
    *   Configuración de persistencia cifrada y consentimiento informado (Ley 1581).
    *   Implementación de seguridad perimetral (Bloqueo de sesión).

2.  **Interfaz y Onboarding:**
    *   Flujo de bienvenida y bautizo de Milo.
    *   Implementación del cuestionario PHQ-9 con sliders empáticos.

3.  **Core de Inteligencia:**
    *   Desarrollo de recolectores pasivos de metadatos (`sensor_kit`).
    *   Integración del motor TFLite para inferencia local (`tflite_service`).
    *   Lógica de calibración de línea base (Baseline).

4.  **Hábitat y Notificaciones:**
    *   Visualización dinámica del hábitat orgánico.
    *   Sistema de estados de ánimo de Milo basados en la salida del MLP.
    *   Gestión de intensidad de acompañamiento y modo oscuro.

5.  **Seguridad y Soporte de Crisis:**
    *   Activación automática de alertas de riesgo.
    *   Dashboard de crisis offline y botón de ayuda inmediata persistente.

---
**Fecha de generación:** 4 de mayo de 2026
**Estado del Proyecto:** Implementación de MVP completada y validada.
