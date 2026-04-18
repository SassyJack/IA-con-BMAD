part of 'dialogue_bloc.dart';

class DialogueState extends Equatable {
  const DialogueState({
    this.currentIndex = 0,
    this.isCompleted = false,
  });

  final int currentIndex;
  final bool isCompleted;

  DialogueState copyWith({
    int? currentIndex,
    bool? isCompleted,
  }) {
    return DialogueState(
      currentIndex: currentIndex ?? this.currentIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentIndex, isCompleted];
}
