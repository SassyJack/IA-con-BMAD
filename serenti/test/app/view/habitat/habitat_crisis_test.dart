import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serenti/app/logic/habitat/habitat_cubit.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';
import 'package:serenti/app/view/habitat/habitat_page.dart';
import 'package:serenti/app/view/habitat/widgets/crisis_action_button.dart';
import 'package:serenti/app/view/habitat/widgets/habitat_background.dart';
import 'package:isar_database/isar_database.dart';

class MockHabitatCubit extends MockCubit<HabitatState> implements HabitatCubit {}
class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState> implements OnboardingBloc {}
class MockPetBloc extends MockBloc<PetEvent, PetState> implements PetBloc {}

void main() {
  late HabitatCubit habitatCubit;
  late OnboardingBloc onboardingBloc;
  late PetBloc petBloc;

  setUp(() {
    habitatCubit = MockHabitatCubit();
    onboardingBloc = MockOnboardingBloc();
    petBloc = MockPetBloc();

    when(() => onboardingBloc.state).thenReturn(const OnboardingState(status: OnboardingStatus.complete));
    when(() => petBloc.state).thenReturn(const PetState(name: 'Milo'));
  });

  Widget createWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: habitatCubit),
        BlocProvider.value(value: onboardingBloc),
        BlocProvider.value(value: petBloc),
      ],
      child: const MaterialApp(
        home: HabitatPage(),
      ),
    );
  }

  group('HabitatPage - Crisis Integration', () {
    testWidgets('shows CrisisActionButton when isHighRisk is true', (tester) async {
      when(() => habitatCubit.state).thenReturn(const HabitatState(isHighRisk: true));

      await tester.pumpWidget(createWidget());
      await tester.pump(); 
      await tester.pump(const Duration(milliseconds: 500)); 

      expect(find.byType(CrisisActionButton), findsOneWidget);
    });

    testWidgets('hides CrisisActionButton when isHighRisk is false', (tester) async {
      when(() => habitatCubit.state).thenReturn(const HabitatState(isHighRisk: false));

      await tester.pumpWidget(createWidget());
      await tester.pump();

      expect(find.byType(CrisisActionButton), findsNothing);
    });

    testWidgets('HabitatBackground receives isHighRisk property', (tester) async {
      when(() => habitatCubit.state).thenReturn(const HabitatState(isHighRisk: true));

      await tester.pumpWidget(createWidget());

      final background = tester.widget<HabitatBackground>(find.byType(HabitatBackground));
      expect(background.isHighRisk, isTrue);
    });
  });
}
