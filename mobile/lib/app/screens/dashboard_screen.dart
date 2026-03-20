import 'package:flutter/material.dart';

import '../../business/auth/entity/auth_result.dart';
import '../../business/onboarding/entity/onboarding_profile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.authResult, required this.profile, required this.onEdit});

  final AuthResult authResult;
  final OnboardingProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Zalogowano jako ${authResult.email}. Redirect: ${authResult.redirectTo}'),
          const SizedBox(height: 16),
          Text('Wiek: ${profile.age}'),
          Text('Cel: ${profile.goal}'),
          Text('Dni: ${profile.trainingDays.join(', ')}'),
          Text('Sprzęt: ${profile.availableEquipment.join(', ')}'),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onEdit, child: const Text('Edytuj onboarding')),
        ]),
      ),
    );
  }
}
