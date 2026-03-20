import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/platforma_treningowa_app.dart';
import 'business/auth/boundary/auth_bloc.dart';
import 'business/auth/control/auth_repository.dart';
import 'business/legal_consent/boundary/legal_consent_bloc.dart';
import 'business/legal_consent/control/legal_consent_repository.dart';
import 'business/onboarding/boundary/onboarding_bloc.dart';
import 'business/onboarding/control/onboarding_repository.dart';

void main() {
  runApp(const PlatformaTreningowaBootstrap());
}

class PlatformaTreningowaBootstrap extends StatelessWidget {
  const PlatformaTreningowaBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => LegalConsentRepository()),
        RepositoryProvider(create: (_) => OnboardingRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(context.read<AuthRepository>())),
          BlocProvider(create: (context) => LegalConsentBloc(context.read<LegalConsentRepository>())),
          BlocProvider(create: (context) => OnboardingBloc(context.read<OnboardingRepository>())),
        ],
        child: const PlatformaTreningowaApp(),
      ),
    );
  }
}
