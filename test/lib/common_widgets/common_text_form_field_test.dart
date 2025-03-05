import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/common_widgets/common_text_form_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/localized_pump.dart';

void main() {
  Future<Widget> createWidgetUnderTest(
    WidgetTester tester, {
    required String inputHint,
    required String labelText,
    ValueChanged<String>? onChange,
    bool obscureText = false,
    IconData? icon,
  }) async {
    await tester.localizedPump(
      CommonTextFormField(
        inputHint: inputHint,
        labelText: labelText,
        onChange: onChange ?? (String value) {},
        obscureText: obscureText,
        icon: icon,
      ),
    );
    return tester.firstWidget(find.byType(CommonTextFormField));
  }

  testWidgets('displays labelText, hintText, and icon',
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

    final Finder labelFinder = find.text(labelText);
    final Finder hintFinder = find.text(inputHint);
    final Finder iconFinder = find.byIcon(icon);

    expect(labelFinder, findsOneWidget);
    expect(hintFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
  });

  testWidgets('ensures obscureText is false by default',
      (WidgetTester tester) async {
    const String labelText = 'Password';
    const String inputHint = 'Enter your password';

    await createWidgetUnderTest(
      tester,
      inputHint: inputHint,
      labelText: labelText,
    );

    final Finder textFieldFinder = find.byType(CommonTextFormField);
    final CommonTextFormField textField =
        tester.widget<CommonTextFormField>(textFieldFinder);
    expect(textField.obscureText, isFalse);
  });

  testWidgets('ensures obscureText is enabled when obscureText is true',
      (WidgetTester tester) async {
    const String labelText = 'Password';
    const String inputHint = 'Enter your password';

    await createWidgetUnderTest(
      tester,
      inputHint: inputHint,
      labelText: labelText,
      obscureText: true,
    );

    final Finder textFieldFinder = find.byType(CommonTextFormField);
    final CommonTextFormField textField =
        tester.widget<CommonTextFormField>(textFieldFinder);
    expect(textField.obscureText, true);
  });
}
