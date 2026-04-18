part of 'phq9_bloc.dart';

enum Phq9Status { initial, loading, success, failure }

class Phq9State extends Equatable {
  const Phq9State({
    this.answers = const [0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.status = Phq9Status.initial,
    this.currentQuestionIndex = 0,
    this.errorMessage,
  });

  final List<int> answers;
  final Phq9Status status;
  final int currentQuestionIndex;
  final String? errorMessage;

  int get totalScore => answers.reduce((a, b) => a + b);

  bool get isLastQuestion => currentQuestionIndex == 8;

  Phq9State copyWith({
    List<int>? answers,
    Phq9Status? status,
    int? currentQuestionIndex,
    String? errorMessage,
  }) {
    return Phq9State(
      answers: answers ?? this.answers,
      status: status ?? this.status,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [answers, status, currentQuestionIndex, errorMessage];
}
