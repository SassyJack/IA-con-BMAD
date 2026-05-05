# -*- coding: utf-8 -*-
"""
Serenti: Robust MLP Training Pipeline (v2.0)
Arquitectura optimizada con BatchNormalization, L2 y Dropout.
"""

import os
import pandas as pd
import numpy as np
import tensorflow as tf
import kagglehub
from kagglehub import KaggleDatasetAdapter
from tensorflow.keras import layers, models, callbacks, regularizers
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report

def load_serenti_functional_features():
    """
    Simulación de carga de StudentLife con datos sintéticos para validar el pipeline.
    En un entorno real, aquí se procesarían los archivos .csv o .json del dataset.
    """
    print("Generando datos sintéticos basados en distribuciones de StudentLife para validación...")
    
    # Creamos 100 perfiles de estudiantes sintéticos
    num_students = 100
    features = []
    labels = []
    
    np.random.seed(42)
    for _ in range(num_students):
        # 1. MOVILIDAD (0 a 10 km/día aprox)
        mobility = np.random.uniform(0.5, 8.0)
        # 2. ACTIVIDAD (0.0 a 1.0)
        activity = np.random.beta(2, 5) # Sesgado a baja actividad
        # 3. SUEÑO (4 a 10 horas)
        sleep = np.random.normal(7, 1.5)
        # 4. SOCIABILIDAD (0 a 50 interacciones)
        social = np.random.poisson(15)
        
        # Etiqueta sintética basada en reglas heurísticas (PHQ-9 aprox)
        # Menos sueño + menos actividad + menos social = más riesgo
        risk_score = (10 - sleep) + (1 - activity)*10 + (20 - social)/5
        label = np.clip(int(risk_score // 4), 0, 3)
        
        features.append([mobility, activity, sleep, social])
        labels.append(label)
            
    return np.array(features), np.array(labels)

# ==========================================
# PIPELINE DE ENTRENAMIENTO ROBUSTO
# ==========================================
try:
    X_raw, y = load_serenti_functional_features()
    
    if len(X_raw) == 0:
        raise ValueError("No se pudieron extraer características.")

    print(f"Procesados {len(X_raw)} perfiles. Iniciando entrenamiento robusto...")

    # Normalización
    scaler = StandardScaler()
    X = scaler.fit_transform(X_raw)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # NUEVA ARQUITECTURA ROBUSTA
    model = models.Sequential([
        # Capa 1: Expansión y Normalización
        layers.Dense(32, activation='relu', input_shape=(4,), 
                     kernel_regularizer=regularizers.l2(0.01)),
        layers.BatchNormalization(),
        layers.Dropout(0.3),
        
        # Capa 2: Refinamiento
        layers.Dense(16, activation='relu', 
                     kernel_regularizer=regularizers.l2(0.01)),
        layers.BatchNormalization(),
        layers.Dropout(0.2),
        
        # Capa 3: Abstracción
        layers.Dense(8, activation='relu'),
        
        # Salida: Clasificación
        layers.Dense(4, activation='softmax')
    ])

    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
        loss='sparse_categorical_crossentropy',
        metrics=['accuracy']
    )

    # Early stopping para evitar sobreentrenamiento
    early_stop = callbacks.EarlyStopping(monitor='val_loss', patience=15, restore_best_weights=True)

    history = model.fit(
        X_train, y_train, 
        epochs=150, 
        batch_size=16, 
        validation_split=0.2, 
        callbacks=[early_stop],
        verbose=1
    )

    # Exportación TFLite optimizada (Cuantización)
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()

    with open('serenti_robust.tflite', 'wb') as f:
        f.write(tflite_model)
        
    print("\n[ÉXITO] Modelo robusto 'serenti_robust.tflite' generado.")

except Exception as e:
    print(f"Error: {e}")
