import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business/health/boundary/health_bloc.dart';

class PlatformaTreningowaApp extends StatelessWidget {
  const PlatformaTreningowaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platforma Treningowa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Platforma Treningowa')),
        body: BlocBuilder<HealthBloc, HealthState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.statusLabel,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'ECB scaffold pod onboarding, plany treningowe i tygodniową adaptację dla runnerów.',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
