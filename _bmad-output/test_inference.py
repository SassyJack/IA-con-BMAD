# -*- coding: utf-8 -*-
"""
Serenti: Inferencia de Validación
Prueba la respuesta del MLP ante escenarios reales.
"""
import numpy as np
import tensorflow as tf
from sklearn.preprocessing import StandardScaler

# 1. Definir los escenarios (Movilidad, Actividad, Sueño, Sociabilidad)
# Nota: Estos valores deben ser normalizados igual que en el entrenamiento
scenarios = np.array([
    [7.5, 0.8, 8.5, 40],  # 1. Saludable: Mucha movilidad, activo, duerme bien, social.
    [3.0, 0.3, 5.0, 10],  # 2. Riesgo Moderado: Poca movilidad, sedentario, poco sueño, baja social.
    [0.2, 0.05, 3.0, 2]   # 3. Crisis: Encierro, casi sin actividad, insomnio, aislado.
])

# Simulamos el escalador (StandardScaler) con los parámetros del entrenamiento
# En una app real, estos parámetros (mean, scale) se exportan junto al modelo.
X_train_mock = np.random.uniform(0, 10, (100, 4)) 
scaler = StandardScaler()
scaler.fit(X_train_mock)
X_test = scaler.transform(scenarios)

# 2. Cargar el modelo generado
try:
    interpreter = tf.lite.Interpreter(model_path="serenti_robust.tflite")
    interpreter.allocate_tensors()

    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    labels = ['NORMAL', 'LEVE', 'MODERADO', 'ALTO']

    print("=== TEST DE INTELIGENCIA DE SERENTI ===\n")

    for i, test_point in enumerate(X_test):
        # Preparar input
        input_data = np.array([test_point], dtype=np.float32)
        interpreter.set_tensor(input_details[0]['index'], input_data)
        
        # Ejecutar inferencia
        interpreter.invoke()
        
        # Obtener resultado (probabilidades)
        output_data = interpreter.get_tensor(output_details[0]['index'])[0]
        prediction = np.argmax(output_data)
        confidence = output_data[prediction] * 100

        print(f"Escenario {i+1}:")
        print(f"  - Sensores: {scenarios[i]}")
        print(f"  - Predicción: {labels[prediction]} ({confidence:.2f}% de confianza)")
        print(f"  - Vector de Probabilidades: {output_data}\n")

except Exception as e:
    print(f"Error en la simulación: {e}")
