import '../entity/auth_result.dart';

class AuthRepository {
  AuthRepository();

  final Map<String, ({String password, bool onboardingCompleted})> _users = {
    'existing.runner@example.com': (password: 'password123', onboardingCompleted: true),
  };

  Future<AuthResult> register({required String email, required String password, required String confirmPassword}) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.containsKey(normalizedEmail)) {
      throw Exception('Użytkownik z tym adresem e-mail już istnieje.');
    }
    _users[normalizedEmail] = (password: password, onboardingCompleted: false);
    return Future<AuthResult>.delayed(
      const Duration(milliseconds: 150),
      () => AuthResult(
        email: normalizedEmail,
        token: 'mock-token-$normalizedEmail',
        onboardingCompleted: false,
        redirectTo: '/onboarding',
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
        redirectTo: user.onboardingCompleted ? '/dashboard' : '/onboarding',
      ),
    );
  }
}
