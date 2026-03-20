import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business/auth/boundary/auth_bloc.dart';
import '../business/onboarding/entity/onboarding_profile.dart';
import '../business/profile/boundary/profile_bloc.dart';
import '../business/profile/control/profile_repository.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/legal_consent_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';

class PlatformaTreningowaApp extends StatefulWidget {
  const PlatformaTreningowaApp({super.key});

  @override
  State<PlatformaTreningowaApp> createState() => _PlatformaTreningowaAppState();
}

class _PlatformaTreningowaAppState extends State<PlatformaTreningowaApp> {
  DateTime? acceptedAt;
  OnboardingProfile? profile;
  bool editingOnboarding = false;
  bool showingProfile = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platforma Treningowa',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final authResult = state.authResult;
          if (authResult != null && !authResult.legalConsentsAccepted) {
            return LegalConsentScreen(
              authResult: authResult,
              onCompleted: (acceptedAtValue) {
                setState(() => acceptedAt = acceptedAtValue);
                context.read<AuthBloc>().add(const AuthLegalConsentsAccepted());
              },
            );
          }
          if (authResult != null && (!authResult.onboardingCompleted || editingOnboarding)) {
            return OnboardingScreen(
              onCompleted: (savedProfile) {
                context.read<ProfileRepository>().setProfile(savedProfile);
                setState(() {
                  profile = savedProfile;
                  editingOnboarding = false;
                  showingProfile = false;
                });
                context.read<AuthBloc>().add(const AuthOnboardingCompleted());
              },
            );
          }
          if (authResult != null && authResult.onboardingCompleted && showingProfile) {
            return BlocProvider(
              create: (context) => ProfileBloc(context.read<ProfileRepository>()),
              child: ProfileScreen(
                email: authResult.email,
                onBack: () => setState(() => showingProfile = false),
                onLogout: () {
                  setState(() {
                    acceptedAt = null;
                    profile = null;
                    editingOnboarding = false;
                    showingProfile = false;
                  });
                  context.read<AuthBloc>().add(const AuthLoggedOut());
                },
              ),
            );
          }
          if (authResult != null && authResult.onboardingCompleted) {
            return DashboardScreen(
              authResult: authResult,
              profile: profile ?? const OnboardingProfile(onboardingCompleted: true),
              onEdit: () => setState(() => editingOnboarding = true),
              onOpenProfile: () => setState(() => showingProfile = true),
              onLogout: () {
                setState(() {
                  acceptedAt = null;
                  profile = null;
                  editingOnboarding = false;
                  showingProfile = false;
                });
                context.read<AuthBloc>().add(const AuthLoggedOut());
              },
            );
          }
          return AuthScreen(acceptedAt: acceptedAt, authResultOverride: authResult);
        },
      ),
    );
  }
}
