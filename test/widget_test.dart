import 'package:flutter_test/flutter_test.dart';
import 'package:mira/main.dart';

void main() {
  testWidgets('MiraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MiraApp());
    expect(find.text('MIRA Assistant'), findsOneWidget);
  });
}
