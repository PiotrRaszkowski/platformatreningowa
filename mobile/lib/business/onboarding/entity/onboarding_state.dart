part of '../boundary/onboarding_bloc.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.step = 0,
    this.profile = const OnboardingProfile(),
    this.isSubmitting = false,
    this.completed = false,
    this.errorMessage,
  });

  final int step;
  final OnboardingProfile profile;
  final bool isSubmitting;
  final bool completed;
  final String? errorMessage;

  OnboardingState copyWith({
    int? step,
    OnboardingProfile? profile,
    bool? isSubmitting,
    bool? completed,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      profile: profile ?? this.profile,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      completed: completed ?? this.completed,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [step, profile, isSubmitting, completed, errorMessage];
}
