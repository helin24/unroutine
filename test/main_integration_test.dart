import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unroutine/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Steps increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // This seems necessary to wait until state has been resolved.
    await tester.pumpAndSettle();

    expect(find.text('Rotation direction'), findsOneWidget);
  });
}