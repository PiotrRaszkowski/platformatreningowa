import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/auth/control/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    test('register returns legal consent redirect for new user', () async {
      final repository = AuthRepository();

      final result = await repository.register(
        email: 'new.runner@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(result.redirectTo, '/legal-consents');
      expect(result.onboardingCompleted, false);
      expect(result.legalConsentsAccepted, false);
    });

    test('login returns dashboard redirect for existing completed user', () async {
      final repository = AuthRepository();

      final result = await repository.login(
        email: 'existing.runner@example.com',
        password: 'password123',
      );

      expect(result.redirectTo, '/dashboard');
      expect(result.onboardingCompleted, true);
      expect(result.legalConsentsAccepted, true);
    });
  });
}
