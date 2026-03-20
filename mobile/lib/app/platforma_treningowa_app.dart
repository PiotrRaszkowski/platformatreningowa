import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';

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
      home: const AuthScreen(),
    );
  }
}
