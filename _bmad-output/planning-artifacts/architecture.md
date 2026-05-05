# Serenti: Architecture Decision Document (ADD)

Este documento define la arquitectura técnica de **Serenti**, una aplicación móvil de salud mental preventiva basada en Edge AI. La arquitectura prioriza la privacidad absoluta (Zero-Cloud) y el rendimiento en dispositivos móviles.

---

## 1. Stack Tecnológico
*   **Framework:** Flutter (Estructura modular via Very Good CLI).
*   **Lenguaje:** Dart (App) / Python (Entrenamiento de IA).
*   **Base de Datos:** Isar Database (NoSQL local con soporte para cifrado AES-256).
*   **Motor de IA:** TensorFlow Lite (Inferencia local).
*   **Seguridad:** Flutter Secure Storage / Biometría.

---

## 2. Arquitectura de Software (Modular)
El proyecto utiliza una arquitectura de paquetes desacoplados para garantizar la mantenibilidad y facilitar el testing:

| Paquete | Responsabilidad |
| :--- | :--- |
| `packages/sensor_kit` | Recolección pasiva de metadatos (GPS, Bluetooth, Acelerómetro, Sensores de Luz). |
| `packages/tflite_service` | Abstracción de la carga e inferencia del modelo `.tflite`. |
| `packages/isar_database` | Gestión de persistencia local y línea base (baseline) del usuario. |
| `packages/security_vault` | Gestión de claves criptográficas y protección de la Ley 1581. |

---

## 3. Especificación del Cerebro AI (MLP v2.0 - Robust)
El núcleo de inteligencia de Serenti es un Perceptrón Multicapa (MLP) robusto optimizado para generalización y estabilidad ante ruidos de sensores.

### A. Capas y Neuronas
*   **Capa de Entrada:** 4 unidades (Fenotipado Digital).
*   **Capa Oculta 1:** 32 neuronas, activación `ReLU` + Regularización `L2(0.01)` + `BatchNormalization` + `Dropout(0.3)`.
*   **Capa Oculta 2:** 16 neuronas, activación `ReLU` + Regularización `L2(0.01)` + `BatchNormalization` + `Dropout(0.2)`.
*   **Capa Oculta 3:** 8 neuronas, activación `ReLU` (Abstracción final).
*   **Capa de Salida:** 4 neuronas, activación `Softmax` (Probabilidades para 4 niveles de riesgo PHQ-9).

### B. Mejoras de Robustez (v2.0)
*   **Batch Normalization:** Estabiliza el aprendizaje y reduce la sensibilidad a la inicialización de pesos.
*   **Regularización L2:** Penaliza pesos excesivos para evitar que un solo sensor (ej: GPS) domine la inferencia.
*   **Dropout Estratificado:** Protege contra el sobreajuste (overfitting) en datasets pequeños.
*   **Cuantización TFLite:** Post-Training Quantization (INT8/Float16) para máxima eficiencia en CPU/NPU móvil.

### B. Variables de Entrada (Features)
1.  **Movilidad:** Velocidad media y entropía de desplazamiento (vía `sensor_kit`).
2.  **Actividad:** Proporción de tiempo activo vs. sedentarismo.
3.  **Sueño:** Inferencia de horas de descanso basada en inactividad de pantalla y sensores de luz.
4.  **Sociabilidad:** Densidad de interacciones detectadas vía proximidad Bluetooth.

### C. Ciclo de Vida del Modelo
*   **Entrenamiento:** Offline usando el dataset **StudentLife** de Dartmouth College.
*   **Cuantización:** Post-Training Quantization para reducir el peso del modelo a < 1MB.
*   **Inferencia:** Realizada en el dispositivo cada 6 horas por el `tflite_service`.

---

## 4. Estrategia de Datos y Privacidad
*   **Zero-Cloud Policy:** Ningún dato personal o de sensores sale del dispositivo.
*   **Cumplimiento Legal:** Diseñado bajo los estándares de la Ley 1581 (Protección de Datos) y 1273 (Delitos Informáticos) de Colombia.
*   **Línea Base:** El sistema requiere 7 días de observación antes de emitir la primera clasificación de riesgo para calibrar el "comportamiento normal" de cada usuario.

---

## 5. Mapeo UI-IA (Milo)
El resultado del MLP (Riesgo 0-3) se traduce directamente en el estado de la mascota digital:
*   **Riesgo 0 (Normal):** Milo activo, colores vibrantes, entorno floreciente.
*   **Riesgo 1-2 (Leve/Moderado):** Milo somnoliento o retraído, colores desaturados.
*   **Riesgo 3 (Crítico):** Activación de protocolos de emergencia y cambio visual drástico en el "Habitat".

---
**Última Actualización:** 2026-04-21
**Estado:** Validado y Sincronizado con el código fuente.
