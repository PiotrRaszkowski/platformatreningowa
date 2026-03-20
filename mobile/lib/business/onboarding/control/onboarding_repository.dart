import '../entity/onboarding_profile.dart';

class OnboardingRepository {
  OnboardingProfile _profile = const OnboardingProfile();

  Future<OnboardingProfile> loadProfile() async => Future<OnboardingProfile>.delayed(const Duration(milliseconds: 100), () => _profile);

  Future<OnboardingProfile> saveProfile(OnboardingProfile profile) async {
    _profile = profile.copyWith(onboardingCompleted: true);
    return Future<OnboardingProfile>.delayed(const Duration(milliseconds: 100), () => _profile);
  }
}
