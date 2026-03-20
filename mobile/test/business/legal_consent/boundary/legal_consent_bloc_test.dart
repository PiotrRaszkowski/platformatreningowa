import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/legal_consent/boundary/legal_consent_bloc.dart';
import 'package:platforma_treningowa_mobile/business/legal_consent/control/legal_consent_repository.dart';
import 'package:platforma_treningowa_mobile/business/legal_consent/entity/legal_consent_state.dart';

void main() {
  group('LegalConsentBloc', () {
    blocTest<LegalConsentBloc, LegalConsentBlocState>(
      'requires all checkboxes before completing',
      build: () => LegalConsentBloc(LegalConsentRepository()),
      seed: () => const LegalConsentBlocState(
        consent: LegalConsentStateModel.initial(),
        token: 'mock-token-new.runner@example.com',
      ),
      act: (bloc) => bloc
        ..add(const LegalConsentTermsToggled(true))
        ..add(const LegalConsentHealthToggled(true))
        ..add(const LegalConsentSubmitted()),
      wait: const Duration(milliseconds: 250),
      expect: () => [
        predicate<LegalConsentBlocState>((state) => state.consent.termsAccepted && !state.consent.healthStatementAccepted),
        predicate<LegalConsentBlocState>((state) => state.consent.termsAccepted && state.consent.healthStatementAccepted),
        predicate<LegalConsentBlocState>((state) => state.isSubmitting),
        predicate<LegalConsentBlocState>((state) => state.errorMessage == 'Zaakceptuj regulamin, oświadczenie zdrowotne i RODO.'),
      ],
    );
  });
}
