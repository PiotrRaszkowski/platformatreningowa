import '../entity/auth_result.dart';

class AuthRepository {
  AuthRepository();

  final Map<String, ({String password, bool onboardingCompleted, bool legalConsentsAccepted})> _users = {
    'existing.runner@example.com': (password: 'password123', onboardingCompleted: true, legalConsentsAccepted: true),
  };

  Future<AuthResult> register({required String email, required String password, required String confirmPassword}) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.containsKey(normalizedEmail)) {
      throw Exception('Użytkownik z tym adresem e-mail już istnieje.');
    }
    _users[normalizedEmail] = (password: password, onboardingCompleted: false, legalConsentsAccepted: false);
    return Future<AuthResult>.delayed(
      const Duration(milliseconds: 150),
      () => AuthResult(
        email: normalizedEmail,
        token: 'mock-token-$normalizedEmail',
        onboardingCompleted: false,
        legalConsentsAccepted: false,
        redirectTo: '/legal-consents',
      ),
    );
  }

  Future<AuthResult> login({required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = _users[normalizedEmail];
    if (user == null || user.password != password) {
      throw Exception('Nieprawidłowy email lub hasło.');
    }
    return Future<AuthResult>.delayed(
      const Duration(milliseconds: 150),
      () => AuthResult(
        email: normalizedEmail,
        token: 'mock-token-$normalizedEmail',
        onboardingCompleted: user.onboardingCompleted,
        legalConsentsAccepted: user.legalConsentsAccepted,
        redirectTo: user.legalConsentsAccepted ? (user.onboardingCompleted ? '/dashboard' : '/onboarding') : '/legal-consents',
      ),
    );
  }
}
