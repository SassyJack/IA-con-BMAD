part of 'phq9_bloc.dart';

abstract class Phq9Event extends Equatable {
  const Phq9Event();

  @override
  List<Object?> get props => [];
}

class Phq9AnswerUpdated extends Phq9Event {
  const Phq9AnswerUpdated(this.questionIndex, this.value);

  final int questionIndex;
  final int value;

  @override
  List<Object?> get props => [questionIndex, value];
}

class Phq9SubmitTest extends Phq9Event {
  const Phq9SubmitTest();
}
