import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serenti/app/data/repositories/legal_repository.dart';

part 'legal_event.dart';
part 'legal_state.dart';

class LegalBloc extends Bloc<LegalEvent, LegalState> {
  LegalBloc({
    required LegalRepository legalRepository,
  })  : _legalRepository = legalRepository,
        super(const LegalState()) {
    on<CheckConsentStatus>(_onCheckConsentStatus);
    on<AcceptConsent>(_onAcceptConsent);
  }

  final LegalRepository _legalRepository;

  Future<void> _onCheckConsentStatus(
    CheckConsentStatus event,
    Emitter<LegalState> emit,
  ) async {
    emit(state.copyWith(status: LegalStatus.loading));
    try {
      final isAccepted = await _legalRepository.hasAcceptedConsent();
      emit(
        state.copyWith(
          status: isAccepted ? LegalStatus.accepted : LegalStatus.required,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: LegalStatus.error));
    }
  }

  Future<void> _onAcceptConsent(
    AcceptConsent event,
    Emitter<LegalState> emit,
  ) async {
    emit(state.copyWith(status: LegalStatus.loading));
    try {
      await _legalRepository.acceptConsent();
      emit(state.copyWith(status: LegalStatus.accepted));
    } catch (_) {
      emit(state.copyWith(status: LegalStatus.error));
    }
  }
}
