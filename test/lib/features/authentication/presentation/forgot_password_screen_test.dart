import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/common_widgets/common_text_form_field.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/forgot_password_screen/forgot_password_screen.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/localized_pump.dart';

void main() {
  Future<Widget> createWidgetUnderTest(WidgetTester tester) async {
    await tester.localizedPump(
      const ForgotPasswordScreen(),
    );
    return tester.firstWidget(find.byType(ForgotPasswordScreen));
  }

  testWidgets('renders ForgotPasswordScreen with title, input, and button',
      (WidgetTester tester) async {
    await createWidgetUnderTest(tester);

    expect(find.text('Forgot Your Password?'), findsOneWidget);
    expect(find.byType(CommonTextFormField), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets(
      'reset password button is disabled when email text field is empty',
      (WidgetTester tester) async {
    await createWidgetUnderTest(tester);

    final Finder button = find.byType(FilledButton);
    expect(button, findsOneWidget);

    final FilledButton buttonWidget = tester.widget(button);
    expect(buttonWidget.onPressed, null);
  });
  testWidgets(
      'reset password button is enabled when email text field is filled',
      (WidgetTester tester) async {
    await createWidgetUnderTest(tester);

    // Find text field and enter text
    final Finder textField = find.byType(CommonTextFormField);
    await tester.enterText(textField, 'test@example.com');
    await tester.pump(); // Rebuild the widget tree

    // Verify button is enabled
    final Finder button = find.byType(FilledButton);
    final FilledButton buttonWidget = tester.widget(button);
    expect(buttonWidget.onPressed, isNotNull);
  });
}
