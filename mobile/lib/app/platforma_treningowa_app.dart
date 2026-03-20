import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/auth/boundary/auth_bloc.dart';
import '../../business/auth/entity/auth_result.dart';
import 'screens/auth_screen.dart';
import 'screens/legal_consent_screen.dart';

class PlatformaTreningowaApp extends StatefulWidget {
  const PlatformaTreningowaApp({super.key});

  @override
  State<PlatformaTreningowaApp> createState() => _PlatformaTreningowaAppState();
}

class _PlatformaTreningowaAppState extends State<PlatformaTreningowaApp> {
  DateTime? acceptedAt;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platforma Treningowa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final authResult = state.authResult;
          if (authResult != null && !authResult.legalConsentsAccepted) {
            return LegalConsentScreen(
              authResult: authResult,
              onCompleted: (acceptedAtValue) {
                setState(() {
                  acceptedAt = acceptedAtValue;
                });
                context.read<AuthBloc>().emitLegalConsentsAccepted();
              },
            );
          }
          return AuthScreen(acceptedAt: acceptedAt, authResultOverride: authResult);
        },
      ),
    );
  }
}
