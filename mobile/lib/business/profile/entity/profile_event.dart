part of '../boundary/profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileLoaded extends ProfileEvent {
  const ProfileLoaded();
}

final class ProfileUpdateSubmitted extends ProfileEvent {
  const ProfileUpdateSubmitted({
    required this.weight,
    required this.trainingDays,
    required this.goal,
    required this.foodIntolerances,
    required this.availableEquipment,
  });

  final String weight;
  final List<String> trainingDays;
  final String goal;
  final String foodIntolerances;
  final List<String> availableEquipment;

  @override
  List<Object?> get props => [weight, trainingDays, goal, foodIntolerances, availableEquipment];
}

final class ProfilePasswordChangeSubmitted extends ProfileEvent {
  const ProfilePasswordChangeSubmitted({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmNewPassword];
}
