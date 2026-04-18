# Product Brief: Serenti
**Estado:** Borrador v1.0  
**Fecha:** 7 de abril de 2026  
**Autor:** Ramón (BMad Product Brief Assistant)

---

## 1. Visión del Producto
**Serenti** es una aplicación móvil de acompañamiento silencioso diseñada para estudiantes universitarios. Utiliza inteligencia artificial local (Edge AI) para detectar de manera pasiva y privada signos tempranos de depresión, transformando datos complejos de comportamiento en una experiencia empática a través de una mascota digital que evoluciona con el estado de ánimo del usuario.

## 2. El Problema
Los estudiantes universitarios enfrentan altos niveles de estrés y riesgo de depresión, pero a menudo no buscan ayuda hasta que están en crisis debido al estigma o la falta de autoconocimiento. Las soluciones actuales suelen ser intrusivas o centralizan datos altamente sensibles en la nube, generando desconfianza sobre la privacidad.

## 3. Público Objetivo
*   **Primario:** Jóvenes universitarios (18-25 años) con acceso a smartphones.
*   **Secundario:** Bienestar universitario y centros de salud estudiantil (como aliados estratégicos).

## 4. Diferenciadores Clave
*   **Privacidad por Diseño (Edge AI):** A diferencia de otras apps, el análisis se realiza 100% en el dispositivo del usuario mediante un modelo **MLP (Perceptrón Multicapa)** optimizado con TensorFlow Lite. Los datos sensibles de salud nunca salen del teléfono, cumpliendo estrictamente con la **Ley 1581 de 2012** y la **Ley 1273 de 2009** de Colombia.
*   **Detección Pasiva:** Basado en el dataset **StudentLife**, la app analiza patrones de movilidad (GPS/WiFi), sueño (acelerómetro/luz) y sociabilidad (micrófono/uso de apps) sin requerir entrada manual constante.
*   **Interfaz Empática (La Mascota):** El estado de salud mental no se presenta como un gráfico frío, sino a través de una mascota que cambia visualmente (ánimo, energía, entorno), reduciendo la ansiedad de la alerta médica.

## 5. Experiencia del Usuario (UX)
1.  **Onboarding y Calibración:** El usuario completa un test **PHQ-9** inicial para establecer su línea base de salud mental.
2.  **Acompañamiento Pasivo:** La app recopila datos en segundo plano durante una ventana longitudinal de 30 días para "entender" la normalidad del estudiante.
3.  **Intervención Amigable:**
    *   **Estado Estable:** La mascota se muestra activa y feliz.
    *   **Detección de Riesgo:** La mascota se muestra decaída o retraída, invitando al usuario a una conversación amable o sugiriendo pausas de bienestar.
    *   **Crisis:** Si el modelo MLP detecta indicadores críticos, se activan consejos directos de manejo de crisis y se muestran líneas de ayuda locales.

## 6. Detalles Técnicos (MVP)
*   **Modelo:** Perceptrón Multicapa (MLP) de 2-3 capas ocultas (~64-16 neuronas).
*   **Entrenamiento:** Pre-entrenado con datasets públicos (*StudentLife*) y refinamiento local mediante transferencia de aprendizaje (opcional).
*   **Plataforma:** Android/iOS (Cross-platform con Flutter o React Native).
*   **Optimización:** Cuantización INT8 para ejecución ultra-rápida (<10ms) y bajo consumo de batería.

## 7. Modelo de Sostenibilidad
Herramienta **gratuita** de impacto social, orientada a ser adoptada por universidades como parte de sus programas de salud pública y retención estudiantil.

---
**Próximos Pasos:**
1. Validar el diseño visual de la mascota (Serenti).
2. Estructurar el **PRD (Product Requirements Document)** detallando los sensores específicos a utilizar.
3. Definir el protocolo de seguridad para el almacenamiento local de los pesos del modelo.
