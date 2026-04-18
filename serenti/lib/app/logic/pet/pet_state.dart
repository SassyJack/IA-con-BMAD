part of 'pet_bloc.dart';

enum PetStatus { initial, loading, success, failure }

class PetState extends Equatable {
  const PetState({
    this.name = '',
    this.gender = PetGender.neutral,
    this.status = PetStatus.initial,
    this.currentMood = MiloMood.idle,
    this.errorMessage,
  });

  final String name;
  final PetGender gender;
  final PetStatus status;
  final MiloMood currentMood;
  final String? errorMessage;

  bool get isNameValid => name.length >= 2 && name.length <= 20;
  bool get isFormValid => isNameValid;

  PetState copyWith({
    String? name,
    PetGender? gender,
    PetStatus? status,
    MiloMood? currentMood,
    String? errorMessage,
  }) {
    return PetState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      currentMood: currentMood ?? this.currentMood,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [name, gender, status, currentMood, errorMessage];
}
