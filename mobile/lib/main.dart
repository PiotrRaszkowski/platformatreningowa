import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/platforma_treningowa_app.dart';
import 'business/health/boundary/health_bloc.dart';
import 'business/health/control/health_repository.dart';

void main() {
  runApp(const PlatformaTreningowaBootstrap());
}

class PlatformaTreningowaBootstrap extends StatelessWidget {
  const PlatformaTreningowaBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => const HealthRepository(),
      child: BlocProvider(
        create: (context) => HealthBloc(context.read<HealthRepository>())..add(const HealthStarted()),
        child: const PlatformaTreningowaApp(),
      ),
    );
  }
}
