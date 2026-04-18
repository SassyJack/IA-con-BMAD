import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serenti/app/data/repositories/phq9_repository.dart';

part 'phq9_event.dart';
part 'phq9_state.dart';

class Phq9Bloc extends Bloc<Phq9Event, Phq9State> {
  Phq9Bloc({
    required Phq9Repository phq9Repository,
  })  : _phq9Repository = phq9Repository,
        super(const Phq9State()) {
    on<Phq9AnswerUpdated>(_onAnswerUpdated);
    on<Phq9SubmitTest>(_onSubmitTest);
  }

  final Phq9Repository _phq9Repository;

  void _onAnswerUpdated(
    Phq9AnswerUpdated event,
    Emitter<Phq9State> emit,
  ) {
    final newAnswers = List<int>.from(state.answers);
    newAnswers[event.questionIndex] = event.value;
    
    emit(state.copyWith(
      answers: newAnswers,
      currentQuestionIndex: event.questionIndex,
      status: Phq9Status.initial,
    ));
  }

  Future<void> _onSubmitTest(
    Phq9SubmitTest event,
    Emitter<Phq9State> emit,
  ) async {
    emit(state.copyWith(status: Phq9Status.loading));

    try {
      await _phq9Repository.saveResult(
        answers: state.answers,
        totalScore: state.totalScore,
      );
      emit(state.copyWith(status: Phq9Status.success));
    } catch (e) {
      emit(state.copyWith(
        status: Phq9Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
