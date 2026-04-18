import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dialogue_event.dart';
part 'dialogue_state.dart';

class DialogueBloc extends Bloc<DialogueEvent, DialogueState> {
  DialogueBloc() : super(const DialogueState()) {
    on<DialogueNextPressed>(_onNextPressed);
    on<DialogueReset>(_onReset);
  }

  void _onNextPressed(
    DialogueNextPressed event,
    Emitter<DialogueState> emit,
  ) {
    if (state.currentIndex < 2) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    } else {
      emit(state.copyWith(isCompleted: true));
    }
  }

  void _onReset(
    DialogueReset event,
    Emitter<DialogueState> emit,
  ) {
    emit(const DialogueState());
  }
}
