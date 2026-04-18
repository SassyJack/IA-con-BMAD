---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
inputDocuments:
  - '_bmad-output/planning-artifacts/prd.md'
  - '_bmad-output/planning-artifacts/product-brief.md'
  - '_bmad-output/brainstorming/brainstorming-session-2026-03-30-120000.md'
  - '_bmad-output/planning-artifacts/architecture.md'
project_name: 'Serenti'
user_name: 'Ramón'
date: '2026-04-08'
---

# UX Design Specification Serenti

**Author:** Ramón
**Date:** 2026-04-08

---

## Resumen Ejecutivo

### Visión del Proyecto
Serenti transforma el monitoreo pasivo de salud mental en una experiencia de acompañamiento empático mediante una mascota digital. Utiliza Edge AI para garantizar privacidad absoluta, convirtiendo indicadores de comportamiento complejos en una interfaz amable que reduce el estigma y facilita la intervención temprana en estudiantes universitarios.

### Usuarios Objetivo
Estudiantes universitarios de 18 a 25 años, nativos digitales, con altos niveles de estrés académico y reticentes a buscar ayuda clínica tradicional. Valoran la privacidad extrema y las interfaces que no se sienten como herramientas médicas.

---

## Experiencia Central del Usuario

### Definición de la Experiencia
La experiencia de Serenti se centra en el "Acompañamiento Pasivo Empático". El usuario no interactúa con una herramienta médica, sino con un compañero digital que refleja su bienestar interno a través de cambios sutiles en su comportamiento y entorno.

### Estrategia de Plataforma
*   **Plataforma:** App Móvil (iOS/Android).
*   **Requisitos Técnicos:** Procesamiento Edge AI (TFLite), ejecución en segundo plano y persistencia de datos 100% offline.

### Interacciones "Sin Esfuerzo"
*   **Sincronización de Sensores Invisible:** No requiere entrada de datos manual.
*   **Interfaz Ambiental:** El estado de ánimo se comunica visualmente antes que con texto.

---

## Respuesta Emocional Deseada

### Objetivos Emocionales Principales
El objetivo central es que el usuario sienta **"Acompañamiento sin Juicio"**. Serenti debe evocar calma, seguridad y una sensación de alivio al saber que su estado emocional es validado de forma privada.

---

## Base del Sistema de Diseño

### Elección del Sistema de Diseño
Se ha seleccionado un **Sistema Tematizable basado en Material 3**, personalizado con la fuente **Nunito** y una paleta de tonos pastel.

### Estrategia de Personalización
*   **Tipografía:** Nunito (Sans-Serif Humanista) por su calidez.
*   **Color:** Paleta de tonos pastel (Azul Serenti, Verde Menta, Lavanda).
*   **Formas:** Geometría orgánica con bordes altamente redondeados (24px+).

---

## Decisión de Dirección de Diseño

### Chosen Direction: Entorno Orgánico
Se ha seleccionado el **Entorno Orgánico** como la identidad visual maestra. Esta dirección utiliza degradados dinámicos y elementos de la naturaleza que reaccionan a los datos de los sensores.

---

## User Journey Flows

### El Vistazo de Validación (Uso Diario)
Apertura de App -> Reflejo Visual (Hábitat) -> Interacción Táctil Opcional -> Cierre con sensación de acompañamiento.

### Detección de Riesgo y Reflexión
Detección de anomalía -> Cambio Ambiental -> Notificación Empática -> Diálogo con la Mascota -> Acción sugerida.

### Protocolo de Crisis (Ayuda Inmediata)
Alerta Crítica Visual -> Botón Persistente -> Dashboard de Recursos Offline -> Líneas de Emergencia locales.

---

## Estrategia de Componentes

### Componentes Personalizados (Custom)
*   **El Hábitat Orgánico:** Contenedor visual inmersivo que traduce datos de sensores en un entorno natural animado.
*   **La Mascota Empática:** Interfaz emocional central (Milo).
*   **Botón de Crisis "Ancla":** Acceso rápido a recursos de emergencia; aumenta su prominencia proporcionalmente al riesgo.

---

## Patrones de Consistencia de UX

### Jerarquía de Botones
Primario (Pill-shaped, Azul Serenti), Secundario (Outline), Emergencia (Coral Suave persistente).

### Feedback de la Mascota
La mascota es el principal indicador de éxito o error mediante animaciones y mensajes en primera persona del plural ("Milo y yo...").

---

## Diseño Responsivo y Accesibilidad

### Estrategia de Accesibilidad (Cumplimiento AA)
*   **Visual:** Contraste optimizado y doble codificación (color + animación) para daltonismo.
*   **Lectura:** Etiquetas descriptivas ARIA para que la mascota "hable" sus estados emocionales.

### Estrategia de Modo Oscuro: "Noche de Calma"
Actúa como un **Modo de Higiene del Sueño** activo con paleta azul medianoche y transición a ámbar suave ante insomnio, con la mascota en reposo y visualización de un "Cielo de Gratitud".

---
**Diseño UX de Serenti Finalizado con Éxito.** 🎉
