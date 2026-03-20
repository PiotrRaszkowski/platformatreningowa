import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../control/legal_consent_repository.dart';
import '../entity/legal_consent_state.dart';

part '../entity/legal_consent_event.dart';
part '../entity/legal_consent_bloc_state.dart';

class LegalConsentBloc extends Bloc<LegalConsentEvent, LegalConsentBlocState> {
  LegalConsentBloc(this._repository) : super(const LegalConsentBlocState.initial()) {
    on<LegalConsentLoaded>(_onLoaded);
    on<LegalConsentTermsToggled>(_onTermsToggled);
    on<LegalConsentHealthToggled>(_onHealthToggled);
    on<LegalConsentPrivacyToggled>(_onPrivacyToggled);
    on<LegalConsentSubmitted>(_onSubmitted);
  }

  final LegalConsentRepository _repository;

  Future<void> _onLoaded(LegalConsentLoaded event, Emitter<LegalConsentBlocState> emit) async {
    final consent = await _repository.getCurrent(event.token);
    emit(state.copyWith(token: event.token, consent: consent, clearError: true));
  }

  void _onTermsToggled(LegalConsentTermsToggled event, Emitter<LegalConsentBlocState> emit) {
    emit(state.copyWith(consent: state.consent.copyWith(termsAccepted: event.value, completed: false, clearAcceptedAt: true), clearError: true));
  }

  void _onHealthToggled(LegalConsentHealthToggled event, Emitter<LegalConsentBlocState> emit) {
    emit(state.copyWith(consent: state.consent.copyWith(healthStatementAccepted: event.value, completed: false, clearAcceptedAt: true), clearError: true));
  }

  void _onPrivacyToggled(LegalConsentPrivacyToggled event, Emitter<LegalConsentBlocState> emit) {
    emit(state.copyWith(consent: state.consent.copyWith(privacyPolicyAccepted: event.value, completed: false, clearAcceptedAt: true), clearError: true));
  }

  Future<void> _onSubmitted(LegalConsentSubmitted event, Emitter<LegalConsentBlocState> emit) async {
    if (state.token == null) {
      emit(state.copyWith(errorMessage: 'Brak tokenu użytkownika.'));
      return;
    }
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final saved = await _repository.save(
        token: state.token!,
        termsAccepted: state.consent.termsAccepted,
        healthStatementAccepted: state.consent.healthStatementAccepted,
        privacyPolicyAccepted: state.consent.privacyPolicyAccepted,
      );
      emit(state.copyWith(isSubmitting: false, consent: saved, completedNow: true, clearError: true));
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, errorMessage: error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
