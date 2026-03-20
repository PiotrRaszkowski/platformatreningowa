import 'package:flutter/material.dart';

import '../../business/auth/entity/auth_result.dart';
import '../../business/onboarding/entity/onboarding_profile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.authResult,
    required this.profile,
    required this.onEdit,
    required this.onOpenProfile,
    required this.onLogout,
  });

  final AuthResult authResult;
  final OnboardingProfile profile;
  final VoidCallback onEdit;
  final VoidCallback onOpenProfile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          TextButton(onPressed: onLogout, child: const Text('Wyloguj')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zalogowano jako ${authResult.email}. Redirect: ${authResult.redirectTo}'),
            const SizedBox(height: 16),
            Text('Wiek: ${profile.age ?? '-'}'),
            Text('Cel: ${profile.goal.isEmpty ? '-' : profile.goal}'),
            Text('Dni: ${profile.trainingDays.isEmpty ? '-' : profile.trainingDays.join(', ')}'),
            Text('Sprzęt: ${profile.availableEquipment.isEmpty ? '-' : profile.availableEquipment.join(', ')}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: onEdit, child: const Text('Edytuj onboarding'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: onOpenProfile, child: const Text('Mój profil'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
