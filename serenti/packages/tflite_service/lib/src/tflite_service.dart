import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Possible moods for Milo from the model.
enum MiloInferenceMood {
  /// Default state.
  idle,
  /// Happy/Positive state.
  joy,
  /// Resting/Sleeping state.
  rest,
  /// Protective/Low-energy state.
  shelter,
}

/// Result of a TFLite inference.
class InferenceResult {
  /// Constructor.
  const InferenceResult({
    required this.mood,
    required this.confidence,
  });

  /// Detected mood.
  final MiloInferenceMood mood;

  /// Confidence score (0.0 to 1.0).
  final double confidence;
}

/// {@template tflite_service}
/// Service responsible for running Edge AI inference with TFLite.
/// {@endtemplate}
class TfliteService {
  /// {@macro tflite_service}
  TfliteService({
    String modelPath = 'packages/tflite_service/assets/mlp_model.tflite',
  }) : _modelPath = modelPath;

  final String _modelPath;
  Interpreter? _interpreter;

  /// Initializes the interpreter.
  Future<void> init() async {
    _interpreter = await Interpreter.fromAsset(_modelPath);
  }

  /// Runs inference on the provided [input] data.
  /// The input is expected to be a normalized list of doubles.
  Future<InferenceResult> predict(List<double> input) async {
    if (_interpreter == null) await init();

    // Run inference in an isolate to avoid blocking the UI thread.
    return compute(_runInference, {
      'interpreterAddress': _interpreter!.address,
      'input': input,
    });
  }

  /// Static method to be run in an isolate.
  static InferenceResult _runInference(Map<String, dynamic> params) {
    final address = params['interpreterAddress'] as int;
    final input = params['input'] as List<double>;
    
    final interpreter = Interpreter.fromAddress(address);
    
    // Output shape: [1, 4] for 4 classes (idle, joy, rest, shelter)
    final output = List<double>.filled(4, 0).reshape([1, 4]);
    
    interpreter.run([input], output);
    
    final results = (output as List<dynamic>)[0] as List<dynamic>;
    
    // Find the index with the highest probability
    var maxIdx = 0;
    var maxValue = -1.0;
    for (var i = 0; i < results.length; i++) {
      final value = results[i] as double;
      if (value > maxValue) {
        maxValue = value;
        maxIdx = i;
      }
    }

    return InferenceResult(
      mood: MiloInferenceMood.values[maxIdx],
      confidence: maxValue,
    );
  }

  /// Closes the interpreter.
  void dispose() {
    _interpreter?.close();
  }
}
