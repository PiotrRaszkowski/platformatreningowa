import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../control/health_repository.dart';
import '../entity/health_snapshot.dart';

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  HealthBloc(this._repository) : super(const HealthState.initial()) {
    on<HealthStarted>(_onStarted);
  }

  final HealthRepository _repository;

  Future<void> _onStarted(HealthStarted event, Emitter<HealthState> emit) async {
    emit(state.copyWith(isLoading: true));
    final snapshot = await _repository.fetchHealth();
    emit(state.copyWith(isLoading: false, snapshot: snapshot));
  }
}
