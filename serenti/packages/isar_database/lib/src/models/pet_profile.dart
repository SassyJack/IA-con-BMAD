import 'package:isar/isar.dart';

part 'pet_profile.g.dart';

/// Gender options for the pet.
enum PetGender {
  /// Male gender.
  male,
  /// Female gender.
  female,
  /// Neutral gender.
  neutral,
}

@collection
class PetProfile {
  Id id = Isar.autoIncrement;

  late String name;

  @enumerated
  late PetGender gender;
}
