import 'package:flutter_test/flutter_test.dart';
import 'package:credit_score_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CreditScoreApp());

    // Verify that the app launches with a title.
    expect(find.text('Credit Score'), findsOneWidget);
  });
}
