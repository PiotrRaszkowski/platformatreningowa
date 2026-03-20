part of '../boundary/auth_bloc.dart';

enum AuthMode { register, login }

class AuthState extends Equatable {
  const AuthState({
    required this.mode,
    required this.isSubmitting,
    this.errorMessage,
    this.authResult,
  });

  const AuthState.initial() : this(mode: AuthMode.register, isSubmitting: false);

  final AuthMode mode;
  final bool isSubmitting;
  final String? errorMessage;
  final AuthResult? authResult;

  bool get isAuthenticated => authResult != null;

  AuthState copyWith({
    AuthMode? mode,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    AuthResult? authResult,
    bool clearResult = false,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      authResult: clearResult ? null : authResult ?? this.authResult,
    );
  }

  @override
  List<Object?> get props => [mode, isSubmitting, errorMessage, authResult];
}
