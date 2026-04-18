import 'package:isar/isar.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  late bool isOnboardingComplete;

  late bool petCustomized;

  late List<String> pendingSteps;

  DateTime? calibrationStartDate;

  double? averageMobility;

  int? averageSteps;

  int? averageSocial;

  double notificationIntensity = 1.0;
}
