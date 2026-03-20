import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/main.dart';

void main() {
  testWidgets('renders scaffold title', (tester) async {
    await tester.pumpWidget(const PlatformaTreningowaBootstrap());
    await tester.pumpAndSettle();

    expect(find.text('Platforma Treningowa'), findsOneWidget);
    expect(find.textContaining('Backend gotowy do integracji'), findsOneWidget);
  });
}
