import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';
import 'package:serenti/app/logic/phq9/phq9_bloc.dart';
import 'package:serenti/l10n/l10n.dart';
import 'package:isar_database/isar_database.dart';

class Phq9TestPage extends StatelessWidget {
  const Phq9TestPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Phq9TestPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Phq9Bloc, Phq9State>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Phq9Status.success) {
          context.read<OnboardingBloc>().add(const OnboardingCompleteStep('phq9_test'));
        } else if (state.status == Phq9Status.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
        }
      },
      child: const Phq9TestView(),
    );
  }
}

class Phq9TestView extends StatefulWidget {
  const Phq9TestView({super.key});

  @override
  State<Phq9TestView> createState() => _Phq9TestViewState();
}

class _Phq9TestViewState extends State<Phq9TestView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = [
      context.l10n.phq9Question1,
      context.l10n.phq9Question2,
      context.l10n.phq9Question3,
      context.l10n.phq9Question4,
      context.l10n.phq9Question5,
      context.l10n.phq9Question6,
      context.l10n.phq9Question7,
      context.l10n.phq9Question8,
      context.l10n.phq9Question9,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _MiloReactionArea(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return _QuestionPage(
                    index: index,
                    question: questions[index],
                    onNext: () {
                      if (index < 8) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiloReactionArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Phq9Bloc, Phq9State>(
      builder: (context, state) {
        final currentAnswer = state.answers[state.currentQuestionIndex];
        
        // Simple visual mapping for now
        Color miloColor;
        String moodText;
        
        if (currentAnswer == 0) {
          miloColor = const Color(0xFFB9FBC0); // Joy
          moodText = '¡Me alegra oír eso!';
        } else if (currentAnswer == 1) {
          miloColor = const Color(0xFFA2D2FF); // Idle
          moodText = 'Entiendo...';
        } else if (currentAnswer == 2) {
          miloColor = const Color(0xFFEBD9FC); // Rest
          moodText = 'Gracias por compartirlo.';
        } else {
          miloColor = const Color(0xFFFFD1D1); // Shelter/Alert
          moodText = 'Estoy aquí contigo.';
        }

        return Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: miloColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: miloColor.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.pets, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              moodText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuestionPage extends StatelessWidget {
  const _QuestionPage({
    required this.index,
    required this.question,
    required this.onNext,
  });

  final int index;
  final String question;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final options = [
      context.l10n.phq9Option0,
      context.l10n.phq9Option1,
      context.l10n.phq9Option2,
      context.l10n.phq9Option3,
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pregunta ${index + 1} de 9',
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          BlocBuilder<Phq9Bloc, Phq9State>(
            buildWhen: (previous, current) => 
              previous.answers[index] != current.answers[index],
            builder: (context, state) {
              final val = state.answers[index].toDouble();
              return Column(
                children: [
                  Slider(
                    value: val,
                    min: 0,
                    max: 3,
                    divisions: 3,
                    label: options[val.toInt()],
                    onChanged: (newValue) {
                      context.read<Phq9Bloc>().add(
                        Phq9AnswerUpdated(index, newValue.toInt()),
                      );
                    },
                    activeColor: const Color(0xFFA2D2FF),
                  ),
                  Text(
                    options[val.toInt()],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF4F5D75),
                    ),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (index < 8) {
                onNext();
              } else {
                context.read<Phq9Bloc>().add(const Phq9SubmitTest());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA2D2FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(index < 8 ? 'Siguiente' : context.l10n.phq9Submit),
          ),
        ],
      ),
    );
  }
}
