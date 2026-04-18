import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenti/app/logic/dialogue/dialogue_bloc.dart';

void main() {
  group('DialogueBloc', () {
    test('initial state is DialogueState()', () {
      expect(DialogueBloc().state, const DialogueState());
    });

    blocTest<DialogueBloc, DialogueState>(
      'emits updated currentIndex when DialogueNextPressed is added',
      build: () => DialogueBloc(),
      act: (bloc) => bloc.add(const DialogueNextPressed()),
      expect: () => [
        const DialogueState(currentIndex: 1),
      ],
    );

    blocTest<DialogueBloc, DialogueState>(
      'emits isCompleted true when DialogueNextPressed is added at last index',
      build: () => DialogueBloc(),
      seed: () => const DialogueState(currentIndex: 2),
      act: (bloc) => bloc.add(const DialogueNextPressed()),
      expect: () => [
        const DialogueState(currentIndex: 2, isCompleted: true),
      ],
    );

    blocTest<DialogueBloc, DialogueState>(
      'emits initial state when DialogueReset is added',
      build: () => DialogueBloc(),
      seed: () => const DialogueState(currentIndex: 2, isCompleted: true),
      act: (bloc) => bloc.add(const DialogueReset()),
      expect: () => [
        const DialogueState(),
      ],
    );
  });
}
