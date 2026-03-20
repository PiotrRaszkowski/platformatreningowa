import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../onboarding/entity/onboarding_profile.dart';
import '../control/profile_repository.dart';

part '../entity/profile_event.dart';
part '../entity/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository) : super(const ProfileState.initial()) {
    on<ProfileLoaded>(_onLoaded);
    on<ProfileUpdateSubmitted>(_onUpdateSubmitted);
    on<ProfilePasswordChangeSubmitted>(_onPasswordChangeSubmitted);
  }

  final ProfileRepository _repository;

  Future<void> _onLoaded(ProfileLoaded event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final profile = await _repository.loadProfile();
      emit(state.copyWith(profile: profile, isLoading: false));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onUpdateSubmitted(ProfileUpdateSubmitted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isSaving: true, clearError: true, clearSuccess: true));
    try {
      final profile = await _repository.updateProfile(
        weight: event.weight,
        trainingDays: event.trainingDays,
        goal: event.goal,
        foodIntolerances: event.foodIntolerances,
        availableEquipment: event.availableEquipment,
      );
      emit(state.copyWith(profile: profile, isSaving: false, successMessage: 'Profil zaktualizowany.'));
    } catch (error) {
      emit(state.copyWith(isSaving: false, errorMessage: error.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onPasswordChangeSubmitted(ProfilePasswordChangeSubmitted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isSaving: true, clearPasswordError: true, clearPasswordSuccess: true));
    try {
      await _repository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmNewPassword: event.confirmNewPassword,
      );
      emit(state.copyWith(isSaving: false, passwordSuccessMessage: 'Hasło zostało zmienione.'));
    } catch (error) {
      emit(state.copyWith(isSaving: false, passwordErrorMessage: error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
