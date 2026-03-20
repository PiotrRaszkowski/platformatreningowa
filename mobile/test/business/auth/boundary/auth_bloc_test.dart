import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/auth/boundary/auth_bloc.dart';
import 'package:platforma_treningowa_mobile/business/auth/control/auth_repository.dart';

void main() {
  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits validation error for mismatched passwords in register mode',
      build: () => AuthBloc(AuthRepository()),
      act: (bloc) => bloc.add(const AuthSubmitted(
        email: 'runner@example.com',
        password: 'password123',
        confirmPassword: 'password999',
      )),
      expect: () => [
        const AuthState(
          mode: AuthMode.register,
          isSubmitting: false,
          errorMessage: 'Hasła muszą być identyczne.',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'logs in existing user and returns dashboard redirect',
      build: () => AuthBloc(AuthRepository()),
      seed: () => const AuthState(mode: AuthMode.login, isSubmitting: false),
      act: (bloc) => bloc.add(const AuthSubmitted(
        email: 'existing.runner@example.com',
        password: 'password123',
      )),
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const AuthState(mode: AuthMode.login, isSubmitting: true),
        predicate<AuthState>((state) => state.authResult?.redirectTo == '/dashboard' && state.isSubmitting == false),
      ],
    );
  });
}
