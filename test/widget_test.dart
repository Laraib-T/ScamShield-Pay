
import 'package:flutter_test/flutter_test.dart';
import 'package:scamshield_pay/app.dart';

void main() {
  testWidgets('ScamShield Pay app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const ScamShieldApp());

    expect(find.byType(ScamShieldApp), findsOneWidget);
  });
}
