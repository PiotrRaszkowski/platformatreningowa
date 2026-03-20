part of '../boundary/legal_consent_bloc.dart';

sealed class LegalConsentEvent extends Equatable {
  const LegalConsentEvent();

  @override
  List<Object?> get props => [];
}

final class LegalConsentLoaded extends LegalConsentEvent {
  const LegalConsentLoaded(this.token);

  final String token;

  @override
  List<Object?> get props => [token];
}

final class LegalConsentTermsToggled extends LegalConsentEvent {
  const LegalConsentTermsToggled(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

final class LegalConsentHealthToggled extends LegalConsentEvent {
  const LegalConsentHealthToggled(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

final class LegalConsentPrivacyToggled extends LegalConsentEvent {
  const LegalConsentPrivacyToggled(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

final class LegalConsentSubmitted extends LegalConsentEvent {
  const LegalConsentSubmitted();
}
