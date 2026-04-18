import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';
import 'package:serenti/app/view/dialogue/welcome_dialogue_page.dart';

import '../../../helpers/pump_app.dart';

class MockPetBloc extends MockBloc<PetEvent, PetState> implements PetBloc {}
class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState> implements OnboardingBloc {}

void main() {
  group('WelcomeDialoguePage', () {
    late PetBloc petBloc;
    late OnboardingBloc onboardingBloc;

    setUp(() {
      petBloc = MockPetBloc();
      onboardingBloc = MockOnboardingBloc();

      when(() => petBloc.state).thenReturn(const PetState(name: 'Milo'));
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());

      whenListen(petBloc, const Stream<PetState>.empty(), initialState: const PetState(name: 'Milo'));
      whenListen(onboardingBloc, const Stream<OnboardingState>.empty(), initialState: const OnboardingState());
    });

    testWidgets('renders WelcomeDialogueView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const WelcomeDialoguePage(),
        ),
      );
      expect(find.byType(WelcomeDialogueView), findsOneWidget);
    });

    testWidgets('renders first dialogue with pet name', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const WelcomeDialoguePage(),
        ),
      );
      expect(find.textContaining('Milo'), findsOneWidget);
    });

    testWidgets('renders Continue button', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const WelcomeDialoguePage(),
        ),
      );
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}
