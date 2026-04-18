import 'package:isar/isar.dart';

part 'legal_consent.g.dart';

@collection
class LegalConsent {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late bool isAccepted;

  late DateTime acceptedAt;
}
