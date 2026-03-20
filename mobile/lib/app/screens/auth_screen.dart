import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/auth/boundary/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isRegister = state.mode == AuthMode.register;
        return Scaffold(
          appBar: AppBar(title: const Text('Platforma Treningowa')),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<AuthMode>(
                      segments: const [
                        ButtonSegment(value: AuthMode.register, label: Text('Rejestracja')),
                        ButtonSegment(value: AuthMode.login, label: Text('Logowanie')),
                      ],
                      selected: {state.mode},
                      onSelectionChanged: (selection) => context.read<AuthBloc>().add(AuthModeChanged(selection.first)),
                    ),
                    const SizedBox(height: 24),
                    TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Hasło', border: OutlineInputBorder())),
                    if (isRegister) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Powtórz hasło', border: OutlineInputBorder()),
                      ),
                    ],
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                    if (state.authResult != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.green.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Zalogowano jako ${state.authResult!.email}. Redirect: ${state.authResult!.redirectTo}'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => context.read<AuthBloc>().add(
                                AuthSubmitted(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  confirmPassword: _confirmPasswordController.text,
                                ),
                              ),
                      child: Text(state.isSubmitting ? 'Przetwarzanie...' : isRegister ? 'Załóż konto' : 'Zaloguj się'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
