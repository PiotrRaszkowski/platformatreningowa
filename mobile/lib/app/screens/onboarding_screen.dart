import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/onboarding/boundary/onboarding_bloc.dart';
import '../../business/onboarding/entity/onboarding_profile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onCompleted});

  final ValueChanged<OnboardingProfile> onCompleted;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final targetDistanceController = TextEditingController();
  final targetTimeController = TextEditingController();
  final foodController = TextEditingController();

  static const sexes = ['kobieta', 'mężczyzna', 'inna', 'wolę nie podawać'];
  static const bodyTypes = ['szczupły', 'średni', 'nadwaga', 'masywny'];
  static const activityOptions = ['nigdy', 'okazjonalnie', 'regularnie', 'zaawansowany'];
  static const goals = ['schudnąć', 'poprawić kondycję', 'biegać szybciej', 'zacząć się ruszać', 'przygotowanie do zawodów'];
  static const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  static const equipment = ['nic', 'hantle', 'gumy', 'siłownia'];

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(const OnboardingStarted());
  }

  @override
  void dispose() {
    ageController.dispose(); weightController.dispose(); heightController.dispose(); targetDistanceController.dispose(); targetTimeController.dispose(); foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.completed) widget.onCompleted(state.profile);
      },
      builder: (context, state) {
        final profile = state.profile;
        syncControllers(profile);
        return Scaffold(
          appBar: AppBar(title: Text('Ankieta startowa ${state.step + 1}/3')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.step == 0) ...basicStep(profile),
              if (state.step == 1) ...goalStep(profile),
              if (state.step == 2) ...equipmentStep(profile),
              if (state.errorMessage != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton(onPressed: state.step == 0 ? null : () => context.read<OnboardingBloc>().add(OnboardingStepChanged(state.step - 1)), child: const Text('Wstecz')),
                  const Spacer(),
                  FilledButton(
                    onPressed: state.isSubmitting ? null : () {
                      final bloc = context.read<OnboardingBloc>();
                      final error = bloc.validate(state.profile, state.step);
                      if (state.step < 2) {
                        if (error != null) {
                          bloc.add(OnboardingSubmitted());
                        } else {
                          bloc.add(OnboardingStepChanged(state.step + 1));
                        }
                      } else {
                        bloc.add(const OnboardingSubmitted());
                      }
                    },
                    child: Text(state.step < 2 ? 'Dalej' : 'Zapisz i przejdź dalej'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void syncControllers(OnboardingProfile profile) {
    ageController.text = profile.age?.toString() ?? '';
    weightController.text = profile.weight;
    heightController.text = profile.height;
    targetDistanceController.text = profile.targetDistance;
    targetTimeController.text = profile.targetTime;
    foodController.text = profile.foodIntolerances;
  }

  List<Widget> basicStep(OnboardingProfile profile) => [
    TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Wiek', border: OutlineInputBorder()), keyboardType: TextInputType.number, onChanged: (v) => update(profile.copyWith(age: int.tryParse(v)))),
    const SizedBox(height: 12),
    dropdown('Płeć', profile.sex, sexes, (v) => update(profile.copyWith(sex: v ?? ''))),
    const SizedBox(height: 12),
    TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Waga (kg)', border: OutlineInputBorder()), onChanged: (v) => update(profile.copyWith(weight: v))),
    const SizedBox(height: 12),
    TextField(controller: heightController, decoration: const InputDecoration(labelText: 'Wzrost (cm)', border: OutlineInputBorder()), onChanged: (v) => update(profile.copyWith(height: v))),
    const SizedBox(height: 12),
    dropdown('Typ sylwetki', profile.bodyType, bodyTypes, (v) => update(profile.copyWith(bodyType: v ?? ''))),
    const SizedBox(height: 12),
    dropdown('Historia aktywności', profile.activityHistory, activityOptions, (v) => update(profile.copyWith(activityHistory: v ?? ''))),
  ];

  List<Widget> goalStep(OnboardingProfile profile) => [
    Wrap(spacing: 8, runSpacing: 8, children: days.map((day) => FilterChip(label: Text(day), selected: profile.trainingDays.contains(day), onSelected: (_) => toggleDay(profile, day))).toList()),
    const SizedBox(height: 12),
    dropdown('Cel', profile.goal, goals, (v) => update(profile.copyWith(goal: v ?? ''))),
    const SizedBox(height: 12),
    TextField(controller: targetDistanceController, decoration: const InputDecoration(labelText: 'Docelowy dystans (opcjonalnie)', border: OutlineInputBorder()), onChanged: (v) => update(profile.copyWith(targetDistance: v))),
    const SizedBox(height: 12),
    TextField(controller: targetTimeController, decoration: const InputDecoration(labelText: 'Docelowy czas (opcjonalnie)', border: OutlineInputBorder()), onChanged: (v) => update(profile.copyWith(targetTime: v))),
  ];

  List<Widget> equipmentStep(OnboardingProfile profile) => [
    TextField(controller: foodController, decoration: const InputDecoration(labelText: 'Nietolerancje pokarmowe (opcjonalnie)', border: OutlineInputBorder()), maxLines: 3, onChanged: (v) => update(profile.copyWith(foodIntolerances: v))),
    const SizedBox(height: 12),
    Wrap(spacing: 8, runSpacing: 8, children: equipment.map((item) => FilterChip(label: Text(item), selected: profile.availableEquipment.contains(item), onSelected: (_) => toggleEquipment(profile, item))).toList()),
  ];

  Widget dropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) => DropdownButtonFormField<String>(
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    value: value.isEmpty ? null : value,
    items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    onChanged: onChanged,
  );

  void toggleDay(OnboardingProfile profile, String value) {
    final days = profile.trainingDays.contains(value) ? (List.of(profile.trainingDays)..remove(value)) : [...profile.trainingDays, value];
    update(profile.copyWith(trainingDays: days));
  }

  void toggleEquipment(OnboardingProfile profile, String value) {
    final items = profile.availableEquipment.contains(value) ? (List.of(profile.availableEquipment)..remove(value)) : [...profile.availableEquipment, value];
    update(profile.copyWith(availableEquipment: items));
  }

  void update(OnboardingProfile profile) => context.read<OnboardingBloc>().add(OnboardingProfileUpdated(profile));
}
