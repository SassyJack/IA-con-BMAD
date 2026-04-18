import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/data/repositories/phq9_repository.dart';
import 'package:serenti/app/logic/phq9/phq9_bloc.dart';

class MockPhq9Repository extends Mock implements Phq9Repository {}

void main() {
  setUpAll(() {
    registerFallbackValue(<int>[]);
  });

  group('Phq9Bloc', () {
    late Phq9Repository phq9Repository;

    setUp(() {
      phq9Repository = MockPhq9Repository();
    });

    test('initial state is Phq9State()', () {
      expect(Phq9Bloc(phq9Repository: phq9Repository).state, const Phq9State());
    });

    blocTest<Phq9Bloc, Phq9State>(
      'emits updated answers when Phq9AnswerUpdated is added',
      build: () => Phq9Bloc(phq9Repository: phq9Repository),
      act: (bloc) => bloc.add(const Phq9AnswerUpdated(0, 3)),
      expect: () => [
        const Phq9State(
          answers: [3, 0, 0, 0, 0, 0, 0, 0, 0],
          currentQuestionIndex: 0,
        ),
      ],
    );

    blocTest<Phq9Bloc, Phq9State>(
      'emits [loading, success] when Phq9SubmitTest is successful',
      setUp: () {
        when(() => phq9Repository.saveResult(
              answers: any(named: 'answers'),
              totalScore: any(named: 'totalScore'),
            )).thenAnswer((_) async {});
      },
      build: () => Phq9Bloc(phq9Repository: phq9Repository),
      seed: () => const Phq9State(answers: [3, 3, 3, 3, 3, 3, 3, 3, 3]),
      act: (bloc) => bloc.add(const Phq9SubmitTest()),
      expect: () => [
        const Phq9State(
          answers: [3, 3, 3, 3, 3, 3, 3, 3, 3],
          status: Phq9Status.loading,
        ),
        const Phq9State(
          answers: [3, 3, 3, 3, 3, 3, 3, 3, 3],
          status: Phq9Status.success,
        ),
      ],
      verify: (_) {
        verify(() => phq9Repository.saveResult(
              answers: [3, 3, 3, 3, 3, 3, 3, 3, 3],
              totalScore: 27,
            )).called(1);
      },
    );

    blocTest<Phq9Bloc, Phq9State>(
      'emits [loading, failure] when Phq9SubmitTest fails',
      setUp: () {
        when(() => phq9Repository.saveResult(
              answers: any(named: 'answers'),
              totalScore: any(named: 'totalScore'),
            )).thenThrow(Exception('Failed to save'));
      },
      build: () => Phq9Bloc(phq9Repository: phq9Repository),
      seed: () => const Phq9State(answers: [1, 1, 1, 1, 1, 1, 1, 1, 1]),
      act: (bloc) => bloc.add(const Phq9SubmitTest()),
      expect: () => [
        const Phq9State(
          answers: [1, 1, 1, 1, 1, 1, 1, 1, 1],
          status: Phq9Status.loading,
        ),
        const Phq9State(
          answers: [1, 1, 1, 1, 1, 1, 1, 1, 1],
          status: Phq9Status.failure,
          errorMessage: 'Exception: Failed to save',
        ),
      ],
    );
  });
}
