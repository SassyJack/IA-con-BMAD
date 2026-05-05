import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:isar/isar.dart';
import 'package:isar_database/isar_database.dart';
import 'package:serenti/app/data/repositories/inference_repository.dart';
import 'package:serenti/app/logic/risk/risk_state.dart';

class RiskCubit extends Cubit<RiskState> {
  RiskCubit({
    required InferenceRepository inferenceRepository,
    required IsarDatabase isarDatabase,
  })  : _inferenceRepository = inferenceRepository,
        _isarDatabase = isarDatabase,
        super(const RiskState());

  final InferenceRepository _inferenceRepository;
  final IsarDatabase _isarDatabase;
  StreamSubscription<List<MiloState>>? _miloStateSubscription;

  Future<void> checkRisk() async {
    emit(state.copyWith(status: RiskStatus.loading));
    try {
      final isHighRisk = await _inferenceRepository.evaluateRisk();
      emit(state.copyWith(
        isHighRisk: isHighRisk,
        status: RiskStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(status: RiskStatus.failure));
    }
  }

  Future<void> watchMiloStateChanges() async {
    _miloStateSubscription?.cancel();
    final isar = await _isarDatabase.getInstance();
    
    // Check initially
    checkRisk();

    // Then watch for any new MiloState that might trigger a risk change
    _miloStateSubscription = isar.miloStates.where()
        .watch()
        .listen((_) {
      checkRisk();
    });
  }

  @override
  Future<void> close() {
    _miloStateSubscription?.cancel();
    return super.close();
  }
}
