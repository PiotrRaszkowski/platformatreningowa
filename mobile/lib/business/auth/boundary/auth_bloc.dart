import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../control/auth_repository.dart';
import '../entity/auth_result.dart';

part '../entity/auth_event.dart';
part '../entity/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState.initial()) {
    on<AuthModeChanged>(_onModeChanged);
    on<AuthSubmitted>(_onSubmitted);
    on<AuthLegalConsentsAccepted>(_onLegalConsentsAccepted);
  }

  final AuthRepository _repository;

  void _onModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(mode: event.mode, clearError: true, clearResult: true));
  }

  Future<void> _onSubmitted(AuthSubmitted event, Emitter<AuthState> emit) async {
    final validationError = _validate(event, state.mode);
    if (validationError != null) {
      emit(state.copyWith(errorMessage: validationError, clearResult: true));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final result = state.mode == AuthMode.login
          ? await _repository.login(email: event.email, password: event.password)
          : await _repository.register(email: event.email, password: event.password, confirmPassword: event.confirmPassword);
      emit(state.copyWith(isSubmitting: false, authResult: result, clearError: true));
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, errorMessage: error.toString().replaceFirst('Exception: ', ''), clearResult: true));
    }
  }

  void _onLegalConsentsAccepted(AuthLegalConsentsAccepted event, Emitter<AuthState> emit) {
    final authResult = state.authResult;
    if (authResult == null) {
      return;
    }
    emit(state.copyWith(
      authResult: authResult.copyWith(legalConsentsAccepted: true, redirectTo: '/onboarding'),
      clearError: true,
    ));
  }

  String? _validate(AuthSubmitted event, AuthMode mode) {
    final email = event.email.trim();
    if (email.isEmpty) return 'Email jest wymagany.';
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)) return 'Podaj poprawny adres e-mail.';
    if (event.password.isEmpty) return 'Hasło jest wymagane.';
    if (event.password.length < 8) return 'Hasło musi mieć co najmniej 8 znaków.';
    if (mode == AuthMode.register && event.confirmPassword.isEmpty) return 'Potwierdzenie hasła jest wymagane.';
    if (mode == AuthMode.register && event.password != event.confirmPassword) return 'Hasła muszą być identyczne.';
    return null;
  }
}
