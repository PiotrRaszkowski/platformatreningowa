import 'package:equatable/equatable.dart';

class AuthResult extends Equatable {
  const AuthResult({
    required this.email,
    required this.token,
    required this.onboardingCompleted,
    required this.legalConsentsAccepted,
    required this.redirectTo,
  });

  final String email;
  final String token;
  final bool onboardingCompleted;
  final bool legalConsentsAccepted;
  final String redirectTo;

  AuthResult copyWith({
    String? email,
    String? token,
    bool? onboardingCompleted,
    bool? legalConsentsAccepted,
    String? redirectTo,
  }) {
    return AuthResult(
      email: email ?? this.email,
      token: token ?? this.token,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      legalConsentsAccepted: legalConsentsAccepted ?? this.legalConsentsAccepted,
      redirectTo: redirectTo ?? this.redirectTo,
    );
  }

  @override
  List<Object?> get props => [email, token, onboardingCompleted, legalConsentsAccepted, redirectTo];
}
