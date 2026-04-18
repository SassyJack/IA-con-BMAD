import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenti/app/logic/dialogue/dialogue_bloc.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';
import 'package:serenti/l10n/l10n.dart';

class WelcomeDialoguePage extends StatelessWidget {
  const WelcomeDialoguePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const WelcomeDialoguePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialogueBloc(),
      child: const WelcomeDialogueView(),
    );
  }
}

class WelcomeDialogueView extends StatelessWidget {
  const WelcomeDialogueView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DialogueBloc, DialogueState>(
      listener: (context, state) {
        if (state.isCompleted) {
          context.read<OnboardingBloc>().add(const OnboardingCompleteStep('welcome_dialogue'));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                _MiloVisual(),
                const SizedBox(height: 40),
                const _DialogueBubble(),
                const SizedBox(height: 40),
                _NextButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiloVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogueBloc, DialogueState>(
      builder: (context, state) {
        // Milo state changes based on dialogue index
        final isJoy = state.currentIndex % 2 == 0;
        final miloColor = isJoy ? const Color(0xFFB9FBC0) : const Color(0xFFA2D2FF);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: miloColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: miloColor.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            isJoy ? Icons.sentiment_very_satisfied : Icons.pets,
            size: 80,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class _DialogueBubble extends StatelessWidget {
  const _DialogueBubble();

  @override
  Widget build(BuildContext context) {
    final petName = context.select((PetBloc bloc) => bloc.state.name);

    return BlocBuilder<DialogueBloc, DialogueState>(
      builder: (context, state) {
        String text;
        switch (state.currentIndex) {
          case 0:
            text = context.l10n.welcomeDialogue1(petName);
            break;
          case 1:
            text = context.l10n.welcomeDialogue2;
            break;
          case 2:
            text = context.l10n.welcomeDialogue3;
            break;
          default:
            text = '';
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(state.currentIndex),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
                fontFamily: 'Nunito',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogueBloc, DialogueState>(
      builder: (context, state) {
        final isLast = state.currentIndex == 2;
        return ElevatedButton(
          onPressed: () {
            context.read<DialogueBloc>().add(const DialogueNextPressed());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA2D2FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(isLast ? context.l10n.welcomeFinish : context.l10n.welcomeNext),
        );
      },
    );
  }
}
