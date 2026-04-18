part of 'legal_bloc.dart';

sealed class LegalEvent extends Equatable {
  const LegalEvent();

  @override
  List<Object> get props => [];
}

class CheckConsentStatus extends LegalEvent {}

class AcceptConsent extends LegalEvent {}
