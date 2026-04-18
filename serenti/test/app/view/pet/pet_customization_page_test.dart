import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_database/isar_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';
import 'package:serenti/app/view/pet/pet_customization_page.dart';

import '../../../helpers/pump_app.dart';

class MockPetBloc extends MockBloc<PetEvent, PetState> implements PetBloc {}
class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState> implements OnboardingBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const PetNameChanged(''));
    registerFallbackValue(const PetProfileSubmitted());
  });

  group('PetCustomizationPage', () {
    late PetBloc petBloc;
    late OnboardingBloc onboardingBloc;

    setUp(() {
      petBloc = MockPetBloc();
      onboardingBloc = MockOnboardingBloc();

      when(() => petBloc.state).thenReturn(const PetState());
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());

      whenListen(petBloc, const Stream<PetState>.empty(), initialState: const PetState());
      whenListen(onboardingBloc, const Stream<OnboardingState>.empty(), initialState: const OnboardingState());
    });

    testWidgets('renders PetCustomizationView', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const PetCustomizationPage(),
        ),
      );
      expect(find.byType(PetCustomizationView), findsOneWidget);
    });

    testWidgets('adds PetNameChanged when name input changes', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const PetCustomizationPage(),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Milo');
      verify(() => petBloc.add(const PetNameChanged('Milo'))).called(1);
    });

    testWidgets('adds PetGenderChanged when gender is selected', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const PetCustomizationPage(),
        ),
      );
      await tester.tap(find.text('Male'));
      verify(() => petBloc.add(const PetGenderChanged(PetGender.male))).called(1);
    });

    testWidgets('adds PetProfileSubmitted when submit button is pressed', (tester) async {
      when(() => petBloc.state).thenReturn(
        const PetState(name: 'Milo', status: PetStatus.initial),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const PetCustomizationPage(),
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      verify(() => petBloc.add(const PetProfileSubmitted())).called(1);
    });

    testWidgets('adds OnboardingCompleteStep when status is success', (tester) async {
      final stateController = StreamController<PetState>();
      whenListen(petBloc, stateController.stream, initialState: const PetState());

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: petBloc),
            BlocProvider.value(value: onboardingBloc),
          ],
          child: const PetCustomizationPage(),
        ),
      );

      stateController.add(const PetState(status: PetStatus.success));
      await tester.pump();

      verify(() => onboardingBloc.add(const OnboardingCompleteStep('personalization'))).called(1);
    });
  });
}
