import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serenti/app/data/repositories/user_settings_repository.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.notificationIntensity = 1.0,
    this.isLoading = false,
  });

  final double notificationIntensity;
  final bool isLoading;

  SettingsState copyWith({
    double? notificationIntensity,
    bool? isLoading,
  }) {
    return SettingsState(
      notificationIntensity: notificationIntensity ?? this.notificationIntensity,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [notificationIntensity, isLoading];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required UserSettingsRepository userSettingsRepository,
  })  : _userSettingsRepository = userSettingsRepository,
        super(const SettingsState());

  final UserSettingsRepository _userSettingsRepository;

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _userSettingsRepository.getUserSettings();
      emit(state.copyWith(
        notificationIntensity: settings.notificationIntensity,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateNotificationIntensity(double intensity) async {
    emit(state.copyWith(notificationIntensity: intensity));
    try {
      await _userSettingsRepository.updateNotificationIntensity(intensity);
    } catch (_) {
      // Handle error or revert state
    }
  }
}
