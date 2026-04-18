import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_database/isar_database.dart';
import 'package:security_vault/security_vault.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';
import 'package:serenti/app/data/repositories/legal_repository.dart';
import 'package:serenti/app/data/repositories/pet_repository.dart';
import 'package:serenti/app/data/repositories/phq9_repository.dart';
import 'package:serenti/app/data/repositories/sensor_repository.dart';
import 'package:serenti/app/data/repositories/user_settings_repository.dart';
import 'package:serenti/app/logic/habitat/habitat_cubit.dart';
import 'package:serenti/app/logic/legal/legal_bloc.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';
import 'package:serenti/app/logic/phq9/phq9_bloc.dart';
import 'package:serenti/app/logic/risk/risk_cubit.dart';
import 'package:serenti/app/logic/security/security_bloc.dart';
import 'package:serenti/app/logic/settings/settings_cubit.dart';
import 'package:serenti/app/logic/theme/theme_cubit.dart';
import 'package:serenti/app/view/dialogue/welcome_dialogue_page.dart';
import 'package:serenti/app/view/habitat/habitat_page.dart';
import 'package:serenti/app/view/legal_onboarding_page.dart';
import 'package:serenti/app/view/pet/pet_customization_page.dart';
import 'package:serenti/app/view/phq9/phq9_test_page.dart';
import 'package:serenti/app/view/security/lock_screen.dart';
import 'package:serenti/app/view/security/security_setup_page.dart';
import 'package:serenti/app/view/theme/serenti_colors.dart';
import 'package:serenti/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    required LegalRepository legalRepository,
    required SecurityVault securityVault,
    required UserSettingsRepository userSettingsRepository,
    required PetRepository petRepository,
    required Phq9Repository phq9Repository,
    required SensorRepository sensorRepository,
    required InferenceRepository inferenceRepository,
    required IsarDatabase isarDatabase,
    super.key,
  })  : _legalRepository = legalRepository,
        _securityVault = securityVault,
        _userSettingsRepository = userSettingsRepository,
        _petRepository = petRepository,
        _phq9Repository = phq9Repository,
        _sensorRepository = sensorRepository,
        _inferenceRepository = inferenceRepository,
        _isarDatabase = isarDatabase;

  final LegalRepository _legalRepository;
  final SecurityVault _securityVault;
  final UserSettingsRepository _userSettingsRepository;
  final PetRepository _petRepository;
  final Phq9Repository _phq9Repository;
  final SensorRepository _sensorRepository;
  final InferenceRepository _inferenceRepository;
  final IsarDatabase _isarDatabase;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _legalRepository),
        RepositoryProvider.value(value: _securityVault),
        RepositoryProvider.value(value: _userSettingsRepository),
        RepositoryProvider.value(value: _petRepository),
        RepositoryProvider.value(value: _phq9Repository),
        RepositoryProvider.value(value: _sensorRepository),
        RepositoryProvider.value(value: _inferenceRepository),
        RepositoryProvider.value(value: _isarDatabase),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LegalBloc(
              legalRepository: _legalRepository,
            )..add(CheckConsentStatus()),
          ),
          BlocProvider(
            create: (context) => SecurityBloc(
              securityVault: _securityVault,
            )..add(SecurityCheckStatus()),
          ),
          BlocProvider(
            create: (context) => OnboardingBloc(
              userSettingsRepository: _userSettingsRepository,
            )..add(OnboardingCheckStatus()),
          ),
          BlocProvider(
            create: (context) => PetBloc(
              petRepository: _petRepository,
              isarDatabase: _isarDatabase,
            )..add(const LoadPetProfile())..add(const PetWatchMoodChanges()),
          ),
          BlocProvider(
            create: (context) => Phq9Bloc(
              phq9Repository: _phq9Repository,
            ),
          ),
          BlocProvider(
            create: (context) => RiskCubit(
              inferenceRepository: _inferenceRepository,
              isarDatabase: _isarDatabase,
            )..watchMiloStateChanges(),
          ),
          BlocProvider(
            create: (context) => HabitatCubit(
              sensorRepository: _sensorRepository,
              riskCubit: context.read<RiskCubit>(),
            )..startListening(),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(
              userSettingsRepository: _userSettingsRepository,
            )..loadSettings(),
          ),
          BlocProvider(
            create: (context) => ThemeCubit()..startAutoTheme(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SecurityBloc>().add(SecurityCheckStatus());
      _resetInactivityTimer();
    } else if (state == AppLifecycleState.paused) {
      _inactivityTimer?.cancel();
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 1), () {
      context.read<SecurityBloc>().add(SecurityLockSession());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetInactivityTimer(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: SerentiColors.lightTheme,
            darkTheme: SerentiColors.darkTheme,
            themeMode: themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocBuilder<LegalBloc, LegalState>(
              builder: (context, legalState) {
                if (legalState.status == LegalStatus.loading ||
                    legalState.status == LegalStatus.initial) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (legalState.status != LegalStatus.accepted) {
                  return const LegalOnboardingPage();
                }

                return BlocBuilder<SecurityBloc, SecurityState>(
                  builder: (context, securityState) {
                    if (securityState.status == SecurityStatus.loading ||
                        securityState.status == SecurityStatus.initial) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (securityState.status == SecurityStatus.setupRequired) {
                      return const SecuritySetupPage();
                    }

                    if (securityState.status == SecurityStatus.unauthenticated ||
                        securityState.status == SecurityStatus.lockedOut) {
                      return const LockScreen();
                    }

                    if (securityState.status == SecurityStatus.authenticated) {
                      return BlocBuilder<OnboardingBloc, OnboardingState>(
                        builder: (context, onboardingState) {
                          if (onboardingState.status == OnboardingStatus.loading ||
                              onboardingState.status == OnboardingStatus.initial) {
                            return const Scaffold(
                              body: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (onboardingState.pendingSteps
                              .contains('personalization')) {
                            return const PetCustomizationPage();
                          }

                          if (onboardingState.pendingSteps.contains('phq9_test')) {
                            return const Phq9TestPage();
                          }

                          if (onboardingState.pendingSteps
                              .contains('welcome_dialogue')) {
                            return const WelcomeDialoguePage();
                          }

                          return const HabitatPage();
                        },
                      );
                    }

                    return const Scaffold(
                      body: Center(child: Text('Algo salió mal')),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
