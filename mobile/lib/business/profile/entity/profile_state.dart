part of '../boundary/profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
    this.passwordSuccessMessage,
    this.passwordErrorMessage,
  });

  const ProfileState.initial() : this(isLoading: true);

  final OnboardingProfile? profile;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;
  final String? passwordSuccessMessage;
  final String? passwordErrorMessage;

  ProfileState copyWith({
    OnboardingProfile? profile,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
    String? passwordSuccessMessage,
    bool clearPasswordSuccess = false,
    String? passwordErrorMessage,
    bool clearPasswordError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
      passwordSuccessMessage: clearPasswordSuccess ? null : passwordSuccessMessage ?? this.passwordSuccessMessage,
      passwordErrorMessage: clearPasswordError ? null : passwordErrorMessage ?? this.passwordErrorMessage,
    );
  }

  @override
  List<Object?> get props => [profile, isLoading, isSaving, errorMessage, successMessage, passwordSuccessMessage, passwordErrorMessage];
}
