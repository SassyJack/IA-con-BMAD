import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:isar_database/isar_database.dart';
import 'package:security_vault/security_vault.dart';
import 'package:serenti/app/data/repositories/legal_repository.dart';
import 'package:serenti/app/data/repositories/pet_repository.dart';
import 'package:serenti/app/data/repositories/phq9_repository.dart';
import 'package:serenti/app/data/repositories/sensor_repository.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';
import 'package:serenti/app/data/repositories/user_settings_repository.dart';
import 'package:sensor_kit/sensor_kit.dart';
import 'package:tflite_service/tflite_service.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function(LegalRepository, SecurityVault, UserSettingsRepository, PetRepository, Phq9Repository, SensorRepository, InferenceRepository, IsarDatabase) builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  // Initialize modular services
  final securityVault = SecurityVault();
  final isarDatabase = IsarDatabase();
  final sensorKitService = SensorKitService();
  final tfliteService = TfliteService();

  final legalRepository = LegalRepository(
    isarDatabase: isarDatabase,
    securityVault: securityVault,
  );

  final userSettingsRepository = UserSettingsRepository(
    isarDatabase: isarDatabase,
    securityVault: securityVault,
  );

  final petRepository = PetRepository(
    isarDatabase: isarDatabase,
    securityVault: securityVault,
  );

  final phq9Repository = Phq9Repository(
    isarDatabase: isarDatabase,
    securityVault: securityVault,
  );

  final sensorRepository = SensorRepository(
    isarDatabase: isarDatabase,
    sensorKitService: sensorKitService,
  );

  final inferenceRepository = InferenceRepository(
    isarDatabase: isarDatabase,
    tfliteService: tfliteService,
  );

  // Start passive collection
  unawaited(sensorRepository.startCollection());

  // Start Edge AI inference cycle
  inferenceRepository.startPeriodicInference();

  runApp(await builder(
    legalRepository, 
    securityVault, 
    userSettingsRepository, 
    petRepository, 
    phq9Repository, 
    sensorRepository,
    inferenceRepository,
    isarDatabase,
  ));
}
