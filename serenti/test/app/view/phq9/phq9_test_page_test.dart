import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/phq9/phq9_bloc.dart';
import 'package:serenti/app/view/phq9/phq9_test_page.dart';

import '../../../helpers/pump_app.dart';

class MockPhq9Bloc extends MockBloc<Phq9Event, Phq9State> implements Phq9Bloc {}
class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState> implements OnboardingBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Phq9AnswerUpdated(0, 0));
    registerFallbackValue(const Phq9SubmitTest());
  });

  group('Phq9TestPage', () {
    late Phq9Bloc phq9Bloc;
    late OnboardingBloc onboardingBloc;

    setUp(() {
      phq9Bloc = MockPhq9Bloc();
      onboardingBloc = MockOnboardingBloc();

      when(() => phq9Bloc.state).thenReturn(const Phq9State());
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());
      
      // Ensure stream is not null
      whenListen(phq9Bloc, const Stream<Phq9State>.empty(), initialState: const Phq9State());
      whenListen(onboardingBloc, const Stream<OnboardingState>.empty(), initialState: const OnboardingState());
    });

    testWidgets('renders Phq9TestView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: phq9Bloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const Phq9TestPage(),
        ),
      );
      expect(find.byType(Phq9TestView), findsOneWidget);
    });

    testWidgets('adds Phq9AnswerUpdated when slider moves', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: phq9Bloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const Phq9TestPage(),
        ),
      );
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      verify(() => phq9Bloc.add(any(that: isA<Phq9AnswerUpdated>()))).called(1);
    });

    testWidgets('renders Siguiente button on first question', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: phq9Bloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const Phq9TestPage(),
        ),
      );
      expect(find.text('Siguiente'), findsOneWidget);
    });

    testWidgets('adds OnboardingCompleteStep when status is success', (tester) async {
      final stateController = StreamController<Phq9State>();
      whenListen(phq9Bloc, stateController.stream, initialState: const Phq9State());

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: phq9Bloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const Phq9TestPage(),
        ),
      );

      stateController.add(const Phq9State(status: Phq9Status.success));
      await tester.pump();

      verify(() => onboardingBloc.add(const OnboardingCompleteStep('phq9_test'))).called(1);
    });
  });
}
