import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serenti/app/data/repositories/sensor_repository.dart';
import 'package:serenti/app/logic/risk/risk_cubit.dart';
import 'package:serenti/app/logic/risk/risk_state.dart';
import 'package:sensor_kit/sensor_kit.dart';

class HabitatState extends Equatable {
  const HabitatState({
    this.activityLevel = 0.0,
    this.isHighRisk = false,
  });

  final double activityLevel;
  final bool isHighRisk;

  HabitatState copyWith({
    double? activityLevel,
    bool? isHighRisk,
  }) {
    return HabitatState(
      activityLevel: activityLevel ?? this.activityLevel,
      isHighRisk: isHighRisk ?? this.isHighRisk,
    );
  }

  @override
  List<Object> get props => [activityLevel, isHighRisk];
}

class HabitatCubit extends Cubit<HabitatState> {
  HabitatCubit({
    required SensorRepository sensorRepository,
    required RiskCubit riskCubit,
  })  : _sensorRepository = sensorRepository,
        _riskCubit = riskCubit,
        super(const HabitatState()) {
    _riskSubscription = _riskCubit.stream.listen((riskState) {
      updateRisk(riskState.isHighRisk);
    });
    // Set initial value
    updateRisk(_riskCubit.state.isHighRisk);
  }

  final SensorRepository _sensorRepository;
  final RiskCubit _riskCubit;
  StreamSubscription<SensorEvent>? _sensorSubscription;
  StreamSubscription<RiskState>? _riskSubscription;

  void startListening() {
    _sensorSubscription?.cancel();
    _sensorSubscription = _sensorRepository.sensorEvents.listen((event) {
      if (event.type == SensorType.activity || event.type == SensorType.mobility) {
        // Increase activity level on movement
        final newLevel = (state.activityLevel + 0.1).clamp(0.0, 1.0);
        emit(state.copyWith(activityLevel: newLevel));
      } else {
        // Slow decay for other events
        final newLevel = (state.activityLevel - 0.01).clamp(0.0, 1.0);
        emit(state.copyWith(activityLevel: newLevel));
      }
    });
  }

  void updateRisk(bool isHighRisk) {
    emit(state.copyWith(isHighRisk: isHighRisk));
  }

  void updateActivity(double level) {
    emit(state.copyWith(activityLevel: level.clamp(0.0, 1.0)));
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    _riskSubscription?.cancel();
    return super.close();
  }
}
