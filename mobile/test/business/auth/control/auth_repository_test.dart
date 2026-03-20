import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/auth/control/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    test('register returns onboarding redirect for new user', () async {
      final repository = AuthRepository();

      final result = await repository.register(
        email: 'new.runner@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(result.redirectTo, '/onboarding');
      expect(result.onboardingCompleted, false);
    });

    test('login returns dashboard redirect for existing completed user', () async {
      final repository = AuthRepository();

      final result = await repository.login(
        email: 'existing.runner@example.com',
        password: 'password123',
      );

      expect(result.redirectTo, '/dashboard');
      expect(result.onboardingCompleted, true);
    });
  });
}
