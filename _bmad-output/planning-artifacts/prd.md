---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-02b-vision', 'step-02c-executive-summary', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish', 'step-12-complete']
inputDocuments: ['_bmad-output/planning-artifacts/product-brief.md', '_bmad-output/brainstorming/brainstorming-session-2026-03-30-120000.md']
workflowType: 'prd'
project_name: 'Serenti'
user_name: 'Ramón'
date: '2026-04-07'
documentCounts:
  briefCount: 1
  researchCount: 0
  brainstormingCount: 1
  projectDocsCount: 0
classification:
  project_type: 'mobile_app'
  domain: 'healthcare'
  complexity: 'high'
  projectContext: 'greenfield'
---

# Product Requirements Document - Serenti

**Author:** Ramón
**Date:** 2026-04-07

## Executive Summary
**Serenti** es una solución de salud mental móvil diseñada específicamente para la población universitaria. El producto aborda la brecha crítica entre la necesidad de detección temprana de la depresión y la reticencia de los estudiantes a buscar ayuda formal debido al estigma. Mediante la recolección pasiva de datos de comportamiento (movilidad, sueño y sociabilidad), Serenti ofrece un sistema de alerta temprana no intrusivo que se manifiesta a través de una mascota digital empática. El objetivo principal es transformar el monitoreo clínico en un acompañamiento cotidiano que proteja la privacidad del usuario procesando el 100% de la información localmente en el dispositivo (**Edge AI**).

### What Makes This Special
Lo que diferencia a **Serenti** es su arquitectura de **Privacidad por Diseño**, alineada con las leyes 1581 y 1273 de Colombia. A diferencia de las aplicaciones de bienestar convencionales que centralizan datos sensibles, Serenti utiliza un modelo de **Perceptrón Multicapa (MLP)** estático y pre-entrenado que realiza inferencias en tiempo real sin que los datos de salud salgan del smartphone. La innovación reside en la **humanización de los datos**: la mascota interactiva actúa como un puente emocional, traduciendo indicadores complejos de "Digital Phenotyping" en estados visuales comprensibles y amables, permitiendo una intervención preventiva mediante consejos de crisis y notificaciones locales configurables por el usuario.

## Project Classification
*   **Project Type:** Mobile App (Flutter / TFLite)
*   **Domain:** Healthcare (Salud Mental / Digital Phenotyping)
*   **Complexity:** High (Cumplimiento Legal / Edge AI)
*   **Project Context:** Greenfield

## Success Criteria & Measurable Outcomes
*   **Retención Post-Calibración:** El 60% de los usuarios mantienen la aplicación instalada después de los primeros 30 días.
*   **Adopción Inicial:** Alcanzar una base de 1,000 usuarios activos en el primer semestre de despliegue.
*   **Precisión del Modelo MLP:** Lograr un 70% de precisión en la detección de signos de depresión (Dataset StudentLife).
*   **Eficiencia Energética:** El consumo de batería por procesos en segundo plano debe ser menor al 5% diario.
*   **Eficiencia de Almacenamiento:** El instalador de la aplicación debe ser menor a 50MB.
*   **Latencia de Inferencia:** El modelo MLP debe completar su análisis en menos de 100ms.

## User Journeys
1.  **Alejandro (Detección Pasiva):** Tras detectar una caída en su movilidad y sociabilidad, su mascota "Milo" aparece decaída en pantalla y le envía una notificación local invitándolo a caminar, logrando que Alejandro busque apoyo antes de una crisis grave.
2.  **Sofía (Privacidad Absoluta):** Configura la app para uso 100% offline y ajusta la frecuencia de notificaciones, confiando en que sus datos sensibles de salud nunca saldrán de su teléfono (Ley 1581).
3.  **Mateo (Protocolo de Crisis):** Ante una detección de riesgo agudo, la mascota cambia a un estado de alerta empática y activa un botón de "Ayuda Inmediata" con recursos de emergencia y guías de respiración offline.

## Project Scoping & Phased Development

### Phase 1: MVP (Must-Haves)
*   **Core AI:** Modelo MLP estático pre-entrenado (StudentLife) integrado con TFLite.
*   **Sensores:** Recolección pasiva de movilidad (GPS/WiFi), sueño y socialización (metadatos).
*   **Interfaz:** Mascota con nombre personalizable, diálogos empáticos y estados de ánimo fijos.
*   **Seguridad:** PIN de acceso, almacenamiento cifrado AES-256 local y Onboarding legal (Ley 1581).
*   **Intervención:** Notificaciones locales configurables y Dashboard de Crisis offline.

### Phase 2: Growth (Post-MVP)
*   **IA Adaptativa:** Aprendizaje incremental del MLP para adaptarse al ritmo específico de cada estudiante tras 30 días.
*   **Personalización:** Accesorios visuales para la mascota y visualización histórica de patrones de comportamiento (Dashboard local).

### Phase 3: Expansion (Vision)
*   **Red de Apoyo:** Conexión (con consentimiento) a contactos de emergencia o familiares.
*   **Ecosistema Universitario:** Integración con centros de bienestar universitarios para agendar citas rápidas.

## Domain-Specific Requirements
*   **Compliance Legal:** Requiere Consentimiento Informado Expreso (Ley 1581) y Medical Disclaimer claro (no es diagnóstico oficial).
*   **Seguridad Técnica:** Uso de Keystore/Keychain para llaves de cifrado. Aislamiento total de datos (Zero-Cloud Policy).
*   **Resiliencia Académica:** Función "Modo Estudio/Exámenes" para ajustar la sensibilidad del modelo y reducir falsos positivos durante el semestre.

## Functional Requirements (Capability Contract)
*   **FR1:** El usuario puede completar un test PHQ-9 inicial y re-calibraciones semestrales.
*   **FR2:** El sistema establece una línea base de salud mental tras un periodo de gracia de 7 días.
*   **FR3:** El usuario puede bautizar a la mascota e ingresar su nombre y género (u opción neutra) para diálogos personalizados.
*   **FR4:** El sistema recolecta automáticamente metadatos de ubicación, actividad física y socialización de forma cifrada.
*   **FR5:** El sistema ejecuta el modelo MLP localmente cada 6 horas para actualizar el estado de la mascota.
*   **FR6:** El usuario puede configurar la frecuencia de las notificaciones locales (Intensidad de acompañamiento).
*   **FR7:** El sistema activa un acceso persistente a "Ayuda Inmediata" en estados de riesgo alto.
*   **FR8:** El usuario puede proteger la app mediante PIN o biometría con bloqueo automático tras 1 minuto de inactividad.
*   **FR9:** El sistema permite posponer partes del onboarding (excepto legal) para un acceso rápido a la mascota.

## Non-Functional Requirements (Quality Attributes)
*   **NFR1:** La inferencia del MLP debe completar en < 100ms sin bloquear la interfaz.
*   **NFR2:** Las animaciones de la mascota deben renderizarse a un mínimo de 60 FPS estables.
*   **NFR3:** El sistema debe operar al 100% de su capacidad sin conexión a internet.
*   **NFR4:** El diseño debe cumplir con WCAG 2.1 nivel AA para accesibilidad.
*   **NFR5:** El instalador de la app debe pesar menos de 50MB para el MVP.
