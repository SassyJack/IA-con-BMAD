part of 'dialogue_bloc.dart';

abstract class DialogueEvent extends Equatable {
  const DialogueEvent();

  @override
  List<Object?> get props => [];
}

class DialogueNextPressed extends DialogueEvent {
  const DialogueNextPressed();
}

class DialogueReset extends DialogueEvent {
  const DialogueReset();
}
