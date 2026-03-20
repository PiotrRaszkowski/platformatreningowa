import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/legal_consent/boundary/legal_consent_bloc.dart';
import 'package:platforma_treningowa_mobile/business/legal_consent/control/legal_consent_repository.dart';

void main() {
  group('LegalConsentBloc', () {
    blocTest<LegalConsentBloc, LegalConsentBlocState>(
      'requires all checkboxes before completing',
      build: () => LegalConsentBloc(LegalConsentRepository()),
      act: (bloc) => bloc
        ..add(const LegalConsentLoaded('mock-token-new.runner@example.com'))
        ..add(const LegalConsentTermsToggled(true))
        ..add(const LegalConsentHealthToggled(true))
        ..add(const LegalConsentSubmitted()),
      wait: const Duration(milliseconds: 250),
      expect: () => [
        predicate<LegalConsentBlocState>((state) => state.token == 'mock-token-new.runner@example.com'),
        predicate<LegalConsentBlocState>((state) => state.consent.termsAccepted),
        predicate<LegalConsentBlocState>((state) => state.consent.healthStatementAccepted),
        predicate<LegalConsentBlocState>((state) => state.isSubmitting),
        predicate<LegalConsentBlocState>((state) => state.errorMessage == 'Zaakceptuj regulamin, oświadczenie zdrowotne i RODO.'),
      ],
    );
  });
}
