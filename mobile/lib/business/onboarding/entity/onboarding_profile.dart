import 'package:equatable/equatable.dart';

class OnboardingProfile extends Equatable {
  const OnboardingProfile({
    this.age,
    this.sex = '',
    this.weight = '',
    this.height = '',
    this.bodyType = '',
    this.activityHistory = '',
    this.trainingDays = const [],
    this.goal = '',
    this.targetDistance = '',
    this.targetTime = '',
    this.foodIntolerances = '',
    this.availableEquipment = const [],
    this.onboardingCompleted = false,
  });

  final int? age;
  final String sex;
  final String weight;
  final String height;
  final String bodyType;
  final String activityHistory;
  final List<String> trainingDays;
  final String goal;
  final String targetDistance;
  final String targetTime;
  final String foodIntolerances;
  final List<String> availableEquipment;
  final bool onboardingCompleted;

  OnboardingProfile copyWith({
    int? age,
    String? sex,
    String? weight,
    String? height,
    String? bodyType,
    String? activityHistory,
    List<String>? trainingDays,
    String? goal,
    String? targetDistance,
    String? targetTime,
    String? foodIntolerances,
    List<String>? availableEquipment,
    bool? onboardingCompleted,
  }) {
    return OnboardingProfile(
      age: age ?? this.age,
      sex: sex ?? this.sex,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bodyType: bodyType ?? this.bodyType,
      activityHistory: activityHistory ?? this.activityHistory,
      trainingDays: trainingDays ?? this.trainingDays,
      goal: goal ?? this.goal,
      targetDistance: targetDistance ?? this.targetDistance,
      targetTime: targetTime ?? this.targetTime,
      foodIntolerances: foodIntolerances ?? this.foodIntolerances,
      availableEquipment: availableEquipment ?? this.availableEquipment,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  List<Object?> get props => [age, sex, weight, height, bodyType, activityHistory, trainingDays, goal, targetDistance, targetTime, foodIntolerances, availableEquipment, onboardingCompleted];
}
