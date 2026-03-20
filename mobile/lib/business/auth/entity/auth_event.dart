part of '../boundary/auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthModeChanged extends AuthEvent {
  const AuthModeChanged(this.mode);

  final AuthMode mode;

  @override
  List<Object?> get props => [mode];
}

final class AuthSubmitted extends AuthEvent {
  const AuthSubmitted({required this.email, required this.password, this.confirmPassword = ''});

  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [email, password, confirmPassword];
}
