import 'package:equatable/equatable.dart';

enum AppStatusValue { unknown, online, offline }

class AppStatusState extends Equatable {
  const AppStatusState({this.status = AppStatusValue.unknown});

  final AppStatusValue status;

  @override
  List<Object?> get props => [status];
}
