import 'package:flutter_test/flutter_test.dart';
import 'package:fit_yourself/app.dart';

void main() {
  testWidgets('App starts without error', (WidgetTester tester) async {
    await tester.pumpWidget(const FitYourselfApp());
    expect(find.text('Fit Yourself by Exercise'), findsOneWidget);
  });
}
