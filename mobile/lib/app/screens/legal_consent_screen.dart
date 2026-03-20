import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/auth/entity/auth_result.dart';
import '../../business/legal_consent/boundary/legal_consent_bloc.dart';

class LegalConsentScreen extends StatefulWidget {
  const LegalConsentScreen({super.key, required this.authResult, required this.onCompleted});

  final AuthResult authResult;
  final ValueChanged<DateTime?> onCompleted;

  @override
  State<LegalConsentScreen> createState() => _LegalConsentScreenState();
}

class _LegalConsentScreenState extends State<LegalConsentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LegalConsentBloc>().add(LegalConsentLoaded(widget.authResult.token));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LegalConsentBloc, LegalConsentBlocState>(
      listener: (context, state) {
        if (state.completedNow) {
          widget.onCompleted(state.consent.acceptedAt);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Akceptacja regulaminu')),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Regulamin, disclaimer i odpowiedzialność', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        const Text(
                          'Platforma nie zastępuje lekarza ani trenera. Korzystasz z planów na własną odpowiedzialność. '
                          'Jeżeli masz wątpliwości zdrowotne, skonsultuj trening ze specjalistą.',
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          value: state.consent.termsAccepted,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) => context.read<LegalConsentBloc>().add(LegalConsentTermsToggled(value ?? false)),
                          title: const Text('Akceptuję regulamin platformy.'),
                        ),
                        CheckboxListTile(
                          value: state.consent.healthStatementAccepted,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) => context.read<LegalConsentBloc>().add(LegalConsentHealthToggled(value ?? false)),
                          title: const Text('Oświadczam, że biorę odpowiedzialność za stan zdrowia i trening.'),
                        ),
                        CheckboxListTile(
                          value: state.consent.privacyPolicyAccepted,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) => context.read<LegalConsentBloc>().add(LegalConsentPrivacyToggled(value ?? false)),
                          title: const Text('Akceptuję politykę prywatności i RODO.'),
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ],
                        if (state.consent.acceptedAt != null) ...[
                          const SizedBox(height: 12),
                          Text('Zgody zapisane: ${state.consent.acceptedAt!.toIso8601String()}'),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: state.isSubmitting || !state.consent.allChecked
                              ? null
                              : () => context.read<LegalConsentBloc>().add(const LegalConsentSubmitted()),
                          child: Text(state.isSubmitting ? 'Zapisywanie...' : 'Akceptuję i kontynuuję'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
