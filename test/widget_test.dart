import 'package:flutter_test/flutter_test.dart';
import 'package:tese_food/main.dart';

void main() {
  testWidgets('App smoke test — login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const TeseApp());
    expect(find.text('TESE'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
