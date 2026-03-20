import '../entity/legal_consent_state.dart';

class LegalConsentRepository {
  final Map<String, LegalConsentStateModel> _consents = {
    'mock-token-existing.runner@example.com': LegalConsentStateModel(
      termsAccepted: true,
      healthStatementAccepted: true,
      privacyPolicyAccepted: true,
      acceptedAt: DateTime.utc(2026, 3, 20, 12),
      completed: true,
    ),
  };

  Future<LegalConsentStateModel> getCurrent(String token) async {
    return Future<LegalConsentStateModel>.delayed(
      const Duration(milliseconds: 100),
      () => _consents[token] ?? const LegalConsentStateModel.initial(),
    );
  }

  Future<LegalConsentStateModel> save({
    required String token,
    required bool termsAccepted,
    required bool healthStatementAccepted,
    required bool privacyPolicyAccepted,
  }) async {
    if (!termsAccepted || !healthStatementAccepted || !privacyPolicyAccepted) {
      throw Exception('Zaakceptuj regulamin, oświadczenie zdrowotne i RODO.');
    }

    final saved = LegalConsentStateModel(
      termsAccepted: termsAccepted,
      healthStatementAccepted: healthStatementAccepted,
      privacyPolicyAccepted: privacyPolicyAccepted,
      acceptedAt: DateTime.now().toUtc(),
      completed: true,
    );
    _consents[token] = saved;
    return Future<LegalConsentStateModel>.delayed(const Duration(milliseconds: 100), () => saved);
  }
}
