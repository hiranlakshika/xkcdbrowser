import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:xkcdbrowser/main.dart' as app;
import 'package:xkcdbrowser/util/widget_keys.dart' as keys;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Comic test', (WidgetTester tester) async {
    //Start app
    app.main();
    //App needs some time to load data from APIs
    await tester.pumpAndSettle(const Duration(seconds: 15));

    //Testing previous button
    final previousButton = find.byKey(const ValueKey(keys.previousButtonKey));
    expect(previousButton, findsOneWidget);
    await tester.tap(previousButton);
    await tester.pumpAndSettle(const Duration(seconds: 15));

    //Testing next button
    final nextButton = find.byKey(const ValueKey(keys.nextButtonKey));
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle(const Duration(seconds: 15));
  });
}
