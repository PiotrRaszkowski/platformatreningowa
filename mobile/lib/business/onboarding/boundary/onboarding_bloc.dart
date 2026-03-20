import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../control/onboarding_repository.dart';
import '../entity/onboarding_profile.dart';

part '../entity/onboarding_event.dart';
part '../entity/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._repository) : super(const OnboardingState()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingStepChanged>(_onStepChanged);
    on<OnboardingProfileUpdated>(_onUpdated);
    on<OnboardingSubmitted>(_onSubmitted);
  }

  final OnboardingRepository _repository;

  Future<void> _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) async {
    final profile = await _repository.loadProfile();
    emit(state.copyWith(profile: profile));
  }

  void _onStepChanged(OnboardingStepChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(step: event.step, clearError: true));
  }

  void _onUpdated(OnboardingProfileUpdated event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(profile: event.profile, clearError: true));
  }

  Future<void> _onSubmitted(OnboardingSubmitted event, Emitter<OnboardingState> emit) async {
    final error = validate(state.profile, state.step);
    if (error != null) {
      emit(state.copyWith(errorMessage: error));
      return;
    }
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final saved = await _repository.saveProfile(state.profile);
    emit(state.copyWith(isSubmitting: false, profile: saved, completed: true));
  }

  String? validate(OnboardingProfile profile, int step) {
    if (step == 0) {
      if (profile.age == null || profile.age! < 12 || profile.age! > 100) return 'Wiek musi być w zakresie 12-100.';
      if (profile.sex.isEmpty || profile.weight.isEmpty || profile.height.isEmpty || profile.bodyType.isEmpty || profile.activityHistory.isEmpty) return 'Uzupełnij dane podstawowe.';
    }
    if (step == 1) {
      if (profile.trainingDays.isEmpty) return 'Wybierz co najmniej jeden dzień treningowy.';
      if (profile.goal.isEmpty) return 'Wybierz cel.';
    }
    if (step == 2 && profile.availableEquipment.isEmpty) return 'Wybierz dostępny sprzęt.';
    return null;
  }
}
