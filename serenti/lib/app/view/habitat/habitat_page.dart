import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenti/app/logic/habitat/habitat_cubit.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/view/habitat/widgets/habitat_background.dart';
import 'package:serenti/app/view/habitat/widgets/crisis_action_button.dart';
import 'package:serenti/app/view/pet/widgets/pet_avatar.dart';
import 'package:serenti/app/view/settings/settings_page.dart';

class HabitatPage extends StatelessWidget {
  const HabitatPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const HabitatPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Mi Hábitat'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () => Navigator.of(context).push(SettingsPage.route()),
          ),
          BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              if (state.status != OnboardingStatus.complete) {
                return const PendingTasksBadge();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: const _CrisisButtonWrapper(),
      body: Stack(
        children: [
          BlocBuilder<HabitatCubit, HabitatState>(
            builder: (context, state) {
              return HabitatBackground(
                activityLevel: state.activityLevel,
                isHighRisk: state.isHighRisk,
              );
            },
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      if (state.isCalibrating) {
                        return const CalibrationNotice();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const Spacer(),
                  const PetAvatar(size: 150),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '¿Cómo te sientes hoy?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Future interaction logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text('Interactuar con Milo'),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrisisButtonWrapper extends StatelessWidget {
  const _CrisisButtonWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitatCubit, HabitatState>(
      buildWhen: (previous, current) => previous.isHighRisk != current.isHighRisk,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: state.isHighRisk
              ? const CrisisActionButton(key: ValueKey('crisis_button'))
              : const SizedBox.shrink(key: ValueKey('no_button')),
        );
      },
    );
  }
}

class PendingTasksBadge extends StatelessWidget {
  const PendingTasksBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Tooltip(
        message: 'Tienes pasos de personalización pendientes',
        child: InkWell(
          onTap: () {
            // Logic to resume onboarding
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orangeAccent),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.info_outline, size: 16, color: Colors.orange),
                SizedBox(width: 4),
                Text(
                  'Completar perfil',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalibrationNotice extends StatelessWidget {
  const CalibrationNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.blue, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Milo está aprendiendo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Durante los primeros 7 días, Milo estará conociendo tus rutinas para cuidarte mejor.',
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
