import 'package:equatable/equatable.dart';

class AuthResult extends Equatable {
  const AuthResult({
    required this.email,
    required this.token,
    required this.onboardingCompleted,
    required this.redirectTo,
  });

  final String email;
  final String token;
  final bool onboardingCompleted;
  final String redirectTo;

  @override
  List<Object?> get props => [email, token, onboardingCompleted, redirectTo];
}
