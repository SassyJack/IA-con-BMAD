# Serenti: Arquitectura Técnica del Cerebro MLP (Edge AI)

Este documento detalla la implementación, estrategia de datos y pipeline de inteligencia artificial de **Serenti**, enfocándose en el modelo de Perceptrón Multicapa (MLP) para la detección temprana de riesgos de salud mental.

## 1. Visión General: Privacidad por Diseño
El núcleo de Serenti es un motor de **Inferencia Local** que procesa datos de sensores directamente en el dispositivo móvil. Cumpliendo con las leyes 1581 y 1273 de Colombia, el sistema garantiza que los datos de salud nunca salgan del smartphone del usuario (**Zero-Cloud Policy**).

## 2. El Dataset: StudentLife
El modelo ha sido fundamentado y validado utilizando el dataset **StudentLife** de Dartmouth College.
*   **Contexto:** Primer estudio a gran escala que correlaciona datos de sensores de smartphones con el rendimiento académico y la salud mental.
*   **Población:** Estudiantes universitarios (target principal de Serenti).
*   **Etiquetas (Ground Truth):** El entrenamiento utiliza los resultados del cuestionario clínico **PHQ-9** (Patient Health Questionnaire) para clasificar niveles de riesgo.

## 3. Fenotipado Digital: Datos Recolectados
El modelo analiza cuatro dimensiones críticas del comportamiento humano mediante recolección pasiva:

| Dimensión | Fuente de Datos (Features) | Indicador de Salud Mental |
| :--- | :--- | :--- |
| **Movilidad** | GPS, WiFi, Acelerómetro | Distancia recorrida, entropía de lugares, tiempo en casa. |
| **Actividad** | Google Fit / Apple Health API | Niveles de sedentarismo vs. actividad física. |
| **Sueño** | Sensor de luz, uso de pantalla | Duración y regularidad del ciclo circadiano. |
| **Sociabilidad** | Metadatos de llamadas y Bluetooth | Frecuencia de interacciones y proximidad social. |

## 4. Pipeline de Análisis y Entrenamiento

### A. Pre-procesamiento (Análisis Local)
1.  **Agregación Temporal:** Los datos crudos se agrupan en ventanas de 24 horas.
2.  **Normalización:** Los valores se escalan (0 a 1) para asegurar la convergencia del modelo.
3.  **Línea Base (7 Días):** Durante la primera semana, el sistema observa el comportamiento del usuario para definir qué es "normal" antes de emitir su primera inferencia.

### B. Entrenamiento Offline
El entrenamiento **no** ocurre en el dispositivo para preservar la batería:
1.  **Entrenamiento:** Realizado en un entorno controlado con **TensorFlow/Keras** usando el dataset StudentLife.
2.  **Optimización:** Aplicación de **Post-Training Quantization** para reducir el tamaño del modelo.
3.  **Conversión:** El modelo se exporta a formato **.tflite** para su integración en la App.

### C. Inferencia en el Dispositivo (Edge AI)
*   **Motor:** `tflite_service` integrado en la App Flutter.
*   **Frecuencia:** Inferencia cada 6 horas.
*   **Rendimiento:** Latencia de inferencia < 100ms.
*   **Salida:** El resultado numérico se traduce en estados emocionales para la mascota digital "Milo".

## 5. Implementación en el Proyecto
El proyecto Serenti ha integrado esta inteligencia en las siguientes capas:
*   `packages/sensor_kit`: Recolector de datos crudos.
*   `packages/tflite_service`: Ejecutor del modelo MLP.
*   `packages/isar_database`: Persistencia cifrada de inferencias y línea base.
*   `lib/app/logic/habitat`: Mapeo de resultados de IA a la UI de la mascota.

---
**Nota:** Serenti no es una herramienta de diagnóstico médico oficial, sino un sistema de acompañamiento preventivo basado en evidencia de fenotipado digital.
