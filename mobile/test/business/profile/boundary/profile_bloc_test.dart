import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/profile/boundary/profile_bloc.dart';
import 'package:platforma_treningowa_mobile/business/profile/control/profile_repository.dart';

void main() {
  group('ProfileBloc', () {
    blocTest<ProfileBloc, ProfileState>(
      'loads current profile',
      build: () => ProfileBloc(ProfileRepository()),
      act: (bloc) => bloc.add(const ProfileLoaded()),
      wait: const Duration(milliseconds: 150),
      expect: () => [
        const ProfileState(isLoading: true),
        predicate<ProfileState>((state) => state.isLoading == false && state.profile != null),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'updates editable profile fields',
      build: () => ProfileBloc(ProfileRepository()),
      seed: () => const ProfileState(profile: null),
      act: (bloc) {
        bloc.add(const ProfileUpdateSubmitted(
          weight: '74.5',
          trainingDays: ['MON', 'WED'],
          goal: 'poprawić kondycję',
          foodIntolerances: 'laktoza',
          availableEquipment: ['gumy'],
        ));
      },
      wait: const Duration(milliseconds: 150),
      expect: () => [
        const ProfileState(isSaving: true),
        predicate<ProfileState>((state) =>
            state.isSaving == false &&
            state.profile?.weight == '74.5' &&
            state.profile?.trainingDays.contains('MON') == true &&
            state.successMessage == 'Profil zaktualizowany.'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'returns password validation error for wrong current password',
      build: () => ProfileBloc(ProfileRepository()),
      seed: () => const ProfileState(isLoading: false),
      act: (bloc) => bloc.add(const ProfilePasswordChangeSubmitted(
        currentPassword: 'bad-password',
        newPassword: 'newPassword123',
        confirmNewPassword: 'newPassword123',
      )),
      wait: const Duration(milliseconds: 150),
      expect: () => [
        const ProfileState(isSaving: true),
        predicate<ProfileState>((state) => state.isSaving == false && state.passwordErrorMessage == 'Nieprawidłowe aktualne hasło.'),
      ],
    );
  });
}
