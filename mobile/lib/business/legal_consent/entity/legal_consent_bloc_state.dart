part of '../boundary/legal_consent_bloc.dart';

class LegalConsentBlocState extends Equatable {
  const LegalConsentBlocState({
    required this.consent,
    this.token,
    this.isSubmitting = false,
    this.errorMessage,
    this.completedNow = false,
  });

  const LegalConsentBlocState.initial() : this(consent: const LegalConsentStateModel.initial());

  final LegalConsentStateModel consent;
  final String? token;
  final bool isSubmitting;
  final String? errorMessage;
  final bool completedNow;

  LegalConsentBlocState copyWith({
    LegalConsentStateModel? consent,
    String? token,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? completedNow,
  }) {
    return LegalConsentBlocState(
      consent: consent ?? this.consent,
      token: token ?? this.token,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      completedNow: completedNow ?? false,
    );
  }

  @override
  List<Object?> get props => [consent, token, isSubmitting, errorMessage, completedNow];
}
