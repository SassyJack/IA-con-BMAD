import 'package:serenti/app/app.dart';
import 'package:serenti/bootstrap.dart';

Future<void> main() async {
  await bootstrap(
    (legalRepository, securityVault, userSettingsRepository, petRepository, phq9Repository, sensorRepository, inferenceRepository, isarDatabase) => App(
      legalRepository: legalRepository,
      securityVault: securityVault,
      userSettingsRepository: userSettingsRepository,
      petRepository: petRepository,
      phq9Repository: phq9Repository,
      sensorRepository: sensorRepository,
      inferenceRepository: inferenceRepository,
      isarDatabase: isarDatabase,
    ),
  );
}
