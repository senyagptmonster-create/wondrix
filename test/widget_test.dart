import 'package:flutter_test/flutter_test.dart';
import 'package:wondrix/wondrix_app.dart';

void main() {
  testWidgets('WondrixApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WondrixApp());
    await tester.pump();
    expect(find.text('Palette Validator'), findsWidgets);
  });
}
