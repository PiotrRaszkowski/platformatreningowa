import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/onboarding/entity/onboarding_profile.dart';
import '../../business/profile/boundary/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.email, required this.onBack, required this.onLogout});

  final String email;
  final VoidCallback onBack;
  final VoidCallback onLogout;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final weightController = TextEditingController();
  final foodController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  static const allDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  static const goalOptions = ['schudnąć', 'poprawić kondycję', 'biegać szybciej', 'zacząć się ruszać', 'przygotowanie do zawodów'];
  static const equipmentOptions = ['nic', 'hantle', 'gumy', 'siłownia'];
  static const dayLabels = {
    'MON': 'Pon',
    'TUE': 'Wt',
    'WED': 'Śr',
    'THU': 'Czw',
    'FRI': 'Pt',
    'SAT': 'Sob',
    'SUN': 'Ndz',
  };

  bool editing = false;
  bool changingPassword = false;
  List<String> trainingDays = const [];
  List<String> availableEquipment = const [];
  String goal = '';

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileLoaded());
  }

  @override
  void dispose() {
    weightController.dispose();
    foodController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        if (profile != null && !editing) {
          weightController.text = profile.weight;
          foodController.text = profile.foodIntolerances;
          trainingDays = List.of(profile.trainingDays);
          availableEquipment = List.of(profile.availableEquipment);
          goal = profile.goal;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mój profil'),
            leading: IconButton(onPressed: widget.onBack, icon: const Icon(Icons.arrow_back)),
            actions: [
              TextButton(onPressed: widget.onLogout, child: const Text('Wyloguj')),
            ],
          ),
          body: state.isLoading && profile == null
              ? const Center(child: CircularProgressIndicator())
              : profile == null
                  ? Center(child: Text(state.errorMessage ?? 'Nie udało się załadować profilu.'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (state.successMessage != null) ...[
                          _MessageBox(message: state.successMessage!, isError: false),
                          const SizedBox(height: 12),
                        ],
                        if (state.errorMessage != null) ...[
                          _MessageBox(message: state.errorMessage!, isError: true),
                          const SizedBox(height: 12),
                        ],
                        if (!editing) ...[
                          _ProfileReadOnlyCard(email: widget.email, profile: profile),
                          const SizedBox(height: 16),
                          FilledButton(onPressed: () => setState(() => editing = true), child: const Text('Edytuj profil')),
                        ] else ...[
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Waga (kg)', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: goal.isEmpty ? null : goal,
                            decoration: const InputDecoration(labelText: 'Cel', border: OutlineInputBorder()),
                            items: goalOptions.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                            onChanged: (value) => setState(() => goal = value ?? ''),
                          ),
                          const SizedBox(height: 12),
                          const Text('Dni treningowe'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: allDays.map((day) => FilterChip(
                              label: Text(dayLabels[day] ?? day),
                              selected: trainingDays.contains(day),
                              onSelected: (_) => setState(() {
                                trainingDays = trainingDays.contains(day)
                                    ? (List.of(trainingDays)..remove(day))
                                    : [...trainingDays, day];
                              }),
                            )).toList(),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: foodController,
                            maxLines: 3,
                            decoration: const InputDecoration(labelText: 'Nietolerancje pokarmowe', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 12),
                          const Text('Dostępny sprzęt'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: equipmentOptions.map((item) => FilterChip(
                              label: Text(item),
                              selected: availableEquipment.contains(item),
                              onSelected: (_) => setState(() {
                                availableEquipment = availableEquipment.contains(item)
                                    ? (List.of(availableEquipment)..remove(item))
                                    : [...availableEquipment, item];
                              }),
                            )).toList(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: state.isSaving
                                      ? null
                                      : () => context.read<ProfileBloc>().add(ProfileUpdateSubmitted(
                                            weight: weightController.text,
                                            trainingDays: trainingDays,
                                            goal: goal,
                                            foodIntolerances: foodController.text,
                                            availableEquipment: availableEquipment,
                                          )),
                                  child: Text(state.isSaving ? 'Zapisywanie...' : 'Zapisz'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => setState(() => editing = false),
                                  child: const Text('Anuluj'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text('Zmiana hasła', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        if (state.passwordSuccessMessage != null) ...[
                          _MessageBox(message: state.passwordSuccessMessage!, isError: false),
                          const SizedBox(height: 12),
                        ],
                        if (state.passwordErrorMessage != null) ...[
                          _MessageBox(message: state.passwordErrorMessage!, isError: true),
                          const SizedBox(height: 12),
                        ],
                        if (!changingPassword)
                          OutlinedButton(
                            onPressed: () => setState(() => changingPassword = true),
                            child: const Text('Zmień hasło'),
                          )
                        else ...[
                          TextField(
                            controller: currentPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Aktualne hasło', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Nowe hasło', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Powtórz nowe hasło', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonal(
                                  onPressed: state.isSaving
                                      ? null
                                      : () => context.read<ProfileBloc>().add(ProfilePasswordChangeSubmitted(
                                            currentPassword: currentPasswordController.text,
                                            newPassword: newPasswordController.text,
                                            confirmNewPassword: confirmPasswordController.text,
                                          )),
                                  child: const Text('Zapisz nowe hasło'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => setState(() => changingPassword = false),
                                  child: const Text('Anuluj'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
        );
      },
    );
  }
}

class _ProfileReadOnlyCard extends StatelessWidget {
  const _ProfileReadOnlyCard({required this.email, required this.profile});

  final String email;
  final OnboardingProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            Text('Wiek: ${profile.age ?? '-'}'),
            Text('Płeć: ${profile.sex.isEmpty ? '-' : profile.sex}'),
            Text('Waga: ${profile.weight.isEmpty ? '-' : '${profile.weight} kg'}'),
            Text('Wzrost: ${profile.height.isEmpty ? '-' : '${profile.height} cm'}'),
            Text('Sylwetka: ${profile.bodyType.isEmpty ? '-' : profile.bodyType}'),
            Text('Aktywność: ${profile.activityHistory.isEmpty ? '-' : profile.activityHistory}'),
            Text('Cel: ${profile.goal.isEmpty ? '-' : profile.goal}'),
            Text('Dni treningowe: ${profile.trainingDays.isEmpty ? '-' : profile.trainingDays.join(', ')}'),
            Text('Sprzęt: ${profile.availableEquipment.isEmpty ? '-' : profile.availableEquipment.join(', ')}'),
            Text('Nietolerancje: ${profile.foodIntolerances.isEmpty ? 'brak' : profile.foodIntolerances}'),
          ],
        ),
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? scheme.errorContainer : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: TextStyle(color: isError ? scheme.onErrorContainer : scheme.onPrimaryContainer)),
    );
  }
}
