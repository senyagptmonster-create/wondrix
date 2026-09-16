import 'package:flutter_test/flutter_test.dart';
import 'package:wondrix/wondrix_app.dart';

void main() {
  testWidgets('WondrixApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WondrixApp());
    expect(find.text('WONDRIX COLOR LAB'), findsOneWidget);
    expect(find.text('Active Simulation: Normal'), findsOneWidget);
  });
}
