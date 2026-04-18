import 'package:isar/isar.dart';

part 'phq9_result.g.dart';

@collection
class Phq9Result {
  Id id = Isar.autoIncrement;

  /// The date when the test was completed.
  late DateTime date;

  /// The individual answers for the 9 questions (values 0-3).
  late List<int> answers;

  /// The total score (0-27).
  late int totalScore;

  /// The severity level based on the score.
  late String severity;
}
