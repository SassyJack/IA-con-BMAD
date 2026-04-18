import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:serenti/app/data/repositories/pet_repository.dart';

part 'pet_event.dart';
part 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  PetBloc({
    required PetRepository petRepository,
    required IsarDatabase isarDatabase,
  })  : _petRepository = petRepository,
        _isarDatabase = isarDatabase,
        super(const PetState()) {
    on<PetNameChanged>(_onNameChanged);
    on<PetGenderChanged>(_onGenderChanged);
    on<PetProfileSubmitted>(_onProfileSubmitted);
    on<LoadPetProfile>(_onLoadProfile);
    on<PetMoodUpdated>(_onMoodUpdated);
    on<PetWatchMoodChanges>(_onWatchMoodChanges);
  }

  final PetRepository _petRepository;
  final IsarDatabase _isarDatabase;
  StreamSubscription? _moodSubscription;

  void _onNameChanged(
    PetNameChanged event,
    Emitter<PetState> emit,
  ) {
    emit(state.copyWith(name: event.name, status: PetStatus.initial));
  }

  void _onGenderChanged(
    PetGenderChanged event,
    Emitter<PetState> emit,
  ) {
    emit(state.copyWith(gender: event.gender, status: PetStatus.initial));
  }

  Future<void> _onProfileSubmitted(
    PetProfileSubmitted event,
    Emitter<PetState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: PetStatus.loading));

    try {
      await _petRepository.savePetProfile(
        name: state.name,
        gender: state.gender,
      );
      emit(state.copyWith(status: PetStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: PetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadProfile(
    LoadPetProfile event,
    Emitter<PetState> emit,
  ) async {
    emit(state.copyWith(status: PetStatus.loading));

    try {
      final profile = await _petRepository.getPetProfile();
      
      // Load latest mood with safety for mocks/errors
      MiloMood currentMood = MiloMood.idle;
      try {
        final isar = await _isarDatabase.getInstance();
        final latestState = await isar.miloStates.where()
            .sortByTimestampDesc()
            .findFirst();
        if (latestState != null) {
          currentMood = latestState.mood;
        }
      } catch (_) {
        // Fallback to idle if Isar query fails (common in tests)
      }

      if (profile != null) {
        emit(state.copyWith(
          name: profile.name,
          gender: profile.gender,
          currentMood: currentMood,
          status: PetStatus.initial,
        ));
      } else {
        emit(state.copyWith(
          currentMood: currentMood,
          status: PetStatus.initial,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onMoodUpdated(
    PetMoodUpdated event,
    Emitter<PetState> emit,
  ) {
    emit(state.copyWith(currentMood: event.mood));
  }

  Future<void> _onWatchMoodChanges(
    PetWatchMoodChanges event,
    Emitter<PetState> emit,
  ) async {
    _moodSubscription?.cancel();
    final isar = await _isarDatabase.getInstance();
    _moodSubscription = isar.miloStates.where()
        .sortByTimestampDesc()
        .watch(fireImmediately: true)
        .listen((states) {
      if (states.isNotEmpty) {
        add(PetMoodUpdated(states.first.mood));
      }
    });
  }

  @override
  Future<void> close() {
    _moodSubscription?.cancel();
    return super.close();
  }
}
