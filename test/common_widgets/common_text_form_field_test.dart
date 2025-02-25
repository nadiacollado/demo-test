import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/common_widgets/common_text_form_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/localized_widget.dart';

void main() {
  Future<Widget> createWidgetUnderTest(
    WidgetTester tester, {
    required String inputHint,
    required String labelText,
    ValueChanged<String>? onChange,
    bool obscureText = false,
    IconData? icon,
  }) async {
    await renderLocalizedWidget(
      tester,
      Scaffold(
        body: CommonTextformField(
          inputHint: inputHint,
          labelText: labelText,
          onChange: onChange ?? (String value) {},
          obscureText: obscureText,
        ),
      ),
    );
    return tester.firstWidget(find.byType(CommonTextformField));
  }

  testWidgets('CustomTextField displays labelText, hintText, and icon',
      (WidgetTester tester) async {
    const String labelText = 'Username';
    const String inputHint = 'Enter your username';
    const IconData icon = Icons.person;
    final ValueNotifier<String> value = ValueNotifier<String>('');

    await createWidgetUnderTest(
      tester,
      inputHint: inputHint,
      labelText: labelText,
      icon: icon,
      onChange: (String text) => value.value = text,
    );

    debugDumpApp();
    final Finder labelFinder = find.text(labelText);
    final Finder hintFinder = find.text(inputHint);
    final Finder iconFinder = find.byIcon(icon);

    // Assert that all elements are found in the widget tree
    expect(labelFinder, findsOneWidget);
    expect(hintFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
  });

  testWidgets('CustomTextField obscureText works', (WidgetTester tester) async {
    const String labelText = 'Password';
    const String inputHint = 'Enter your password';

    await createWidgetUnderTest(
      tester,
      inputHint: inputHint,
      labelText: labelText,
    );

    final Finder textFieldFinder = find.byType(CommonTextformField);
    final CommonTextformField textField =
        tester.widget<CommonTextformField>(textFieldFinder);
    expect(textField.obscureText, isFalse);
  });

  testWidgets('CustomTextField obscureText works', (WidgetTester tester) async {
    const String labelText = 'Password';
    const String inputHint = 'Enter your password';

    await createWidgetUnderTest(
      tester,
      inputHint: inputHint,
      labelText: labelText,
      obscureText: true,
    );

    final Finder textFieldFinder = find.byType(CommonTextformField);
    final CommonTextformField textField =
        tester.widget<CommonTextformField>(textFieldFinder);
    expect(textField.obscureText, true);
  });
}
