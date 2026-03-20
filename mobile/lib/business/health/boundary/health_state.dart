part of 'health_bloc.dart';

class HealthState extends Equatable {
  const HealthState({required this.isLoading, this.snapshot});

  const HealthState.initial() : this(isLoading: false);

  final bool isLoading;
  final HealthSnapshot? snapshot;

  String get statusLabel {
    if (isLoading) {
      return 'Ładowanie statusu...';
    }
    return snapshot?.status ?? 'Scaffold gotowy';
  }

  HealthState copyWith({bool? isLoading, HealthSnapshot? snapshot}) {
    return HealthState(
      isLoading: isLoading ?? this.isLoading,
      snapshot: snapshot ?? this.snapshot,
    );
  }

  @override
  List<Object?> get props => [isLoading, snapshot];
}
