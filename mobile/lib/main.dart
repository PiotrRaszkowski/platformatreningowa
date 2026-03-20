import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/platforma_treningowa_app.dart';
import 'business/auth/boundary/auth_bloc.dart';
import 'business/auth/control/auth_repository.dart';

void main() {
  runApp(const PlatformaTreningowaBootstrap());
}

class PlatformaTreningowaBootstrap extends StatelessWidget {
  const PlatformaTreningowaBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(context.read<AuthRepository>()),
        child: const PlatformaTreningowaApp(),
      ),
    );
  }
}
