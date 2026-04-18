import 'package:isar/isar.dart';

part 'milo_state.g.dart';

/// Possible moods for Milo.
enum MiloMood {
  /// Default state.
  idle,
  /// Happy/Positive state.
  joy,
  /// Resting/Sleeping state.
  rest,
  /// Protective/Low-energy state.
  shelter,
}

@collection
class MiloState {
  /// Isar Id.
  Id id = Isar.autoIncrement;

  /// Time of the inference.
  late DateTime timestamp;

  /// Detected mood.
  @enumerated
  late MiloMood mood;

  /// Confidence score from the model.
  late double confidenceScore;
}
