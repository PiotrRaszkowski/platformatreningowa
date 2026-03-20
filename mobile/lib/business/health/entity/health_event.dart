part of 'health_bloc.dart';

sealed class HealthEvent extends Equatable {
  const HealthEvent();

  @override
  List<Object?> get props => [];
}

final class HealthStarted extends HealthEvent {
  const HealthStarted();
}
