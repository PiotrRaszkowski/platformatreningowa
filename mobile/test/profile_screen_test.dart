import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/app/screens/profile_screen.dart';
import 'package:platforma_treningowa_mobile/business/profile/boundary/profile_bloc.dart';
import 'package:platforma_treningowa_mobile/business/profile/control/profile_repository.dart';

void main() {
  testWidgets('renders profile screen with edit and logout actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RepositoryProvider(
          create: (_) => ProfileRepository(),
          child: BlocProvider(
            create: (context) => ProfileBloc(context.read<ProfileRepository>()),
            child: ProfileScreen(
              email: 'runner@example.com',
              onBack: () {},
              onLogout: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Mój profil'), findsOneWidget);
    expect(find.text('Edytuj profil'), findsOneWidget);
    expect(find.text('Zmiana hasła'), findsOneWidget);
    expect(find.text('Wyloguj'), findsOneWidget);
  });
}
