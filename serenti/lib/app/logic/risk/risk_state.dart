import 'package:equatable/equatable.dart';

enum RiskStatus { initial, loading, success, failure }

class RiskState extends Equatable {
  const RiskState({
    this.isHighRisk = false,
    this.status = RiskStatus.initial,
  });

  final bool isHighRisk;
  final RiskStatus status;

  RiskState copyWith({
    bool? isHighRisk,
    RiskStatus? status,
  }) {
    return RiskState(
      isHighRisk: isHighRisk ?? this.isHighRisk,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [isHighRisk, status];
}
