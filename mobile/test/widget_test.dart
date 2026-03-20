import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/main.dart';

void main() {
  testWidgets('renders auth screen with registration mode by default', (tester) async {
    await tester.pumpWidget(const PlatformaTreningowaBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('Platforma Treningowa'), findsOneWidget);
    expect(find.text('Rejestracja'), findsOneWidget);
    expect(find.text('Logowanie'), findsOneWidget);
    expect(find.text('Załóż konto'), findsOneWidget);
  });
}
