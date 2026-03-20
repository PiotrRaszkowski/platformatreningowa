import '../../onboarding/entity/onboarding_profile.dart';

class ProfileRepository {
  OnboardingProfile _profile = const OnboardingProfile(onboardingCompleted: true);
  String _password = 'password123';

  Future<OnboardingProfile> loadProfile() async {
    return Future<OnboardingProfile>.delayed(const Duration(milliseconds: 100), () => _profile);
  }

  Future<OnboardingProfile> updateProfile({
    required String weight,
    required List<String> trainingDays,
    required String goal,
    required String foodIntolerances,
    required List<String> availableEquipment,
  }) async {
    _profile = _profile.copyWith(
      weight: weight,
      trainingDays: trainingDays,
      goal: goal,
      foodIntolerances: foodIntolerances,
      availableEquipment: availableEquipment,
    );
    return Future<OnboardingProfile>.delayed(const Duration(milliseconds: 100), () => _profile);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (currentPassword != _password) {
      throw Exception('Nieprawidłowe aktualne hasło.');
    }
    if (newPassword != confirmNewPassword) {
      throw Exception('Nowe hasła muszą być identyczne.');
    }
    if (newPassword.length < 8) {
      throw Exception('Nowe hasło musi mieć co najmniej 8 znaków.');
    }
    _password = newPassword;
  }

  void setProfile(OnboardingProfile profile) {
    _profile = profile;
  }
}
