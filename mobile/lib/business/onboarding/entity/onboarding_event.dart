part of '../boundary/onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

final class OnboardingStepChanged extends OnboardingEvent {
  const OnboardingStepChanged(this.step);
  final int step;
  @override
  List<Object?> get props => [step];
}

final class OnboardingProfileUpdated extends OnboardingEvent {
  const OnboardingProfileUpdated(this.profile);
  final OnboardingProfile profile;
  @override
  List<Object?> get props => [profile];
}

final class OnboardingSubmitted extends OnboardingEvent {
  const OnboardingSubmitted();
}
