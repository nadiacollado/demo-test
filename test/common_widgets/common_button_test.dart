import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/common_widgets/common_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/localized_widget.dart';

void main() {
  Future<Widget> createWidgetUnderTest(
    WidgetTester tester, {
    required String buttonText,
    VoidCallback? onPressed,
    bool isDisabled = false,
    bool isFullWidth = false,
    IconData? icon,
  }) async {
    await renderLocalizedWidget(
      tester,
      Scaffold(
        body: CommonButton(
          text: buttonText,
          onPressed: onPressed ?? () {},
          isDisabled: isDisabled,
          isFullWidth: isFullWidth,
          icon: icon,
        ),
      ),
    );
    return tester.firstWidget(find.byType(CommonButton));
  }

  testWidgets('renders button with text', (WidgetTester tester) async {
    const String buttonText = 'Testing';
    await createWidgetUnderTest(tester, buttonText: buttonText);

    expect(find.text(buttonText), findsOneWidget);
  });
  testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
    bool pressed = false;
    await createWidgetUnderTest(
      tester,
      buttonText: 'Press Me',
      onPressed: () => pressed = true,
    );

    await tester.tap(find.byType(CommonButton));
    await tester.pump();

    expect(pressed, isTrue);
  });
  testWidgets('button is enabled by default', (WidgetTester tester) async {
    await createWidgetUnderTest(tester, buttonText: 'Testing');

    final CommonButton button =
        tester.widget<CommonButton>(find.byType(CommonButton));
    expect(button.isDisabled, isFalse);
  });
  testWidgets('button is disabled if isDisabled is true',
      (WidgetTester tester) async {
    await createWidgetUnderTest(
      tester,
      buttonText: 'Testing',
      isDisabled: true,
    );

    final CommonButton button =
        tester.widget<CommonButton>(find.byType(CommonButton));
    expect(button.isDisabled, isTrue);
  });

  testWidgets('renders button with full width when isFullWidth is true',
      (WidgetTester tester) async {
    await createWidgetUnderTest(
      tester,
      buttonText: 'Full Width Button',
      isFullWidth: true,
    );

    final SizedBox sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.width, double.infinity);
  });

  testWidgets('displays icon when provided', (WidgetTester tester) async {
    const IconData icon = Icons.star;
    const String buttonText = 'Testing Icon';

    await createWidgetUnderTest(
      tester,
      buttonText: buttonText,
      isFullWidth: true,
      icon: icon,
    );

    final Finder iconFinder = find.byIcon(icon);
    final Finder textFinder = find.text(buttonText);

    expect(iconFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });

  testWidgets('does not display icon when not provided',
      (WidgetTester tester) async {
    const String buttonText = 'Testing Null Icon';

    await createWidgetUnderTest(
      tester,
      buttonText: buttonText,
      isFullWidth: true,
    );

    final Finder iconFinder = find.byType(Icon);
    final Finder textFinder = find.text(buttonText);

    expect(iconFinder, findsNothing);
    expect(textFinder, findsOneWidget);
  });
}
