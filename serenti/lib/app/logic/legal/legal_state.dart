part of 'legal_bloc.dart';

enum LegalStatus { initial, loading, required, accepted, error }

class LegalState extends Equatable {
  const LegalState({
    this.status = LegalStatus.initial,
  });

  final LegalStatus status;

  LegalState copyWith({
    LegalStatus? status,
  }) {
    return LegalState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
