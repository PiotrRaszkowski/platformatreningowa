import 'package:equatable/equatable.dart';

abstract class AppStatusEvent extends Equatable {
  const AppStatusEvent();

  @override
  List<Object?> get props => [];
}

class AppStatusRequested extends AppStatusEvent {
  const AppStatusRequested();
}
