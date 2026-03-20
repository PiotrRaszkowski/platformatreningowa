import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/onboarding/boundary/onboarding_bloc.dart';
import 'package:platforma_treningowa_mobile/business/onboarding/control/onboarding_repository.dart';
import 'package:platforma_treningowa_mobile/business/onboarding/entity/onboarding_profile.dart';

void main() {
  group('OnboardingBloc', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'emits validation error when first step data is incomplete',
      build: () => OnboardingBloc(OnboardingRepository()),
      act: (bloc) => bloc.add(const OnboardingSubmitted()),
      expect: () => [predicate<OnboardingState>((state) => state.errorMessage == 'Wiek musi być w zakresie 12-100.')],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'saves completed onboarding profile',
      build: () => OnboardingBloc(OnboardingRepository()),
      seed: () => OnboardingState(profile: const OnboardingProfile(age: 31, sex: 'mężczyzna', weight: '76.5', height: '182', bodyType: 'średni', activityHistory: 'regularnie', trainingDays: ['MON', 'WED'], goal: 'biegać szybciej', targetDistance: '10', targetTime: '50:00', foodIntolerances: 'laktoza', availableEquipment: ['gumy']), step: 2),
      act: (bloc) => bloc.add(const OnboardingSubmitted()),
      wait: const Duration(milliseconds: 150),
      expect: () => [
        predicate<OnboardingState>((state) => state.isSubmitting),
        predicate<OnboardingState>((state) => state.completed && state.profile.onboardingCompleted),
      ],
    );
  });
}
