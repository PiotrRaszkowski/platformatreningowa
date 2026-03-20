import 'package:equatable/equatable.dart';

class HealthSnapshot extends Equatable {
  const HealthSnapshot({required this.status, required this.service});

  final String status;
  final String service;

  @override
  List<Object?> get props => [status, service];
}
