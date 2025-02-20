// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/features/counter/presentation/counter_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/localized_pump.dart';

void main() {
  testWidgets(
    'Counter increments smoke test',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.localizedPump(const CounterScreen());

      // Verify that our counter starts at 0.
      expect(find.text(tester.t.count_counter(0)), findsOneWidget);
      expect(find.text(tester.t.count_counter(1)), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text(tester.t.count_counter(0)), findsNothing);
      expect(find.text(tester.t.count_counter(1)), findsOneWidget);
    },
  );

  testWidgets(
    'Counter decrements correctly',
    (WidgetTester tester) async {
      await tester.localizedPump(const CounterScreen());

      expect(find.text(tester.t.count_counter(0)), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text(tester.t.count_counter(2)), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text(tester.t.count_counter(1)), findsOneWidget);
    },
  );
}
