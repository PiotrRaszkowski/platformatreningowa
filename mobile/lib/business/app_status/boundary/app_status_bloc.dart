import 'package:flutter_bloc/flutter_bloc.dart';

import '../control/app_status_repository.dart';
import '../entity/app_status_event.dart';
import '../entity/app_status_state.dart';

class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  AppStatusBloc({required this.repository})
      : super(const AppStatusState()) {
    on<AppStatusRequested>(_onStatusRequested);
  }

  final AppStatusRepository repository;

  Future<void> _onStatusRequested(
    AppStatusRequested event,
    Emitter<AppStatusState> emit,
  ) async {
    try {
      final status = await repository.checkStatus();
      emit(AppStatusState(status: status));
    } on Exception {
      emit(const AppStatusState(status: AppStatusValue.offline));
    }
  }
}
