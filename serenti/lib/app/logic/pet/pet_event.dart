part of 'pet_bloc.dart';

sealed class PetEvent extends Equatable {
  const PetEvent();

  @override
  List<Object?> get props => [];
}

class PetNameChanged extends PetEvent {
  const PetNameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

class PetGenderChanged extends PetEvent {
  const PetGenderChanged(this.gender);
  final PetGender gender;

  @override
  List<Object?> get props => [gender];
}

class PetProfileSubmitted extends PetEvent {
  const PetProfileSubmitted();
}

class LoadPetProfile extends PetEvent {
  const LoadPetProfile();
}

class PetMoodUpdated extends PetEvent {
  const PetMoodUpdated(this.mood);
  final MiloMood mood;

  @override
  List<Object> get props => [mood];
  }

  class PetInteracted extends PetEvent {
  const PetInteracted();
  }


class PetWatchMoodChanges extends PetEvent {
  const PetWatchMoodChanges();
}
