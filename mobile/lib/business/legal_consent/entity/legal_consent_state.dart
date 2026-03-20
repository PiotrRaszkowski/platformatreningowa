import 'package:equatable/equatable.dart';

class LegalConsentStateModel extends Equatable {
  const LegalConsentStateModel({
    required this.termsAccepted,
    required this.healthStatementAccepted,
    required this.privacyPolicyAccepted,
    required this.completed,
    this.acceptedAt,
  });

  const LegalConsentStateModel.initial()
      : termsAccepted = false,
        healthStatementAccepted = false,
        privacyPolicyAccepted = false,
        acceptedAt = null,
        completed = false;

  final bool termsAccepted;
  final bool healthStatementAccepted;
  final bool privacyPolicyAccepted;
  final DateTime? acceptedAt;
  final bool completed;

  bool get allChecked => termsAccepted && healthStatementAccepted && privacyPolicyAccepted;

  LegalConsentStateModel copyWith({
    bool? termsAccepted,
    bool? healthStatementAccepted,
    bool? privacyPolicyAccepted,
    DateTime? acceptedAt,
    bool? completed,
    bool clearAcceptedAt = false,
  }) {
    return LegalConsentStateModel(
      termsAccepted: termsAccepted ?? this.termsAccepted,
      healthStatementAccepted: healthStatementAccepted ?? this.healthStatementAccepted,
      privacyPolicyAccepted: privacyPolicyAccepted ?? this.privacyPolicyAccepted,
      acceptedAt: clearAcceptedAt ? null : acceptedAt ?? this.acceptedAt,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [termsAccepted, healthStatementAccepted, privacyPolicyAccepted, acceptedAt, completed];
}
