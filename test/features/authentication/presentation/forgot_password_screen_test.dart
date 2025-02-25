import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/common_widgets/common_button.dart';
import 'package:flutter_starter_kit/common_widgets/common_text_form_field.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/forgot_password_screen/forgot_password_screen.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../utils/localized_widget.dart';

void main() {
  Future<Widget> createWidgetUnderTest(WidgetTester tester) async {
    await renderLocalizedWidget(
      tester,
      const Scaffold(
        body: ForgotPasswordScreen(),
      ),
    );
    return tester.firstWidget(find.byType(ForgotPasswordScreen));
  }

  testWidgets('renders ForgotPasswordScreen with title, input, and button',
      (WidgetTester tester) async {
    await createWidgetUnderTest(tester);

    expect(find.text('Forgot Your Password?'), findsOneWidget);
    expect(find.byType(CommonTextformField), findsOneWidget);
    expect(find.byType(CommonButton), findsOneWidget);
  });

  testWidgets(
      'reset password button is disabled when email text field is empty',
      (WidgetTester tester) async {
    await createWidgetUnderTest(tester);

    final Finder button = find.byType(CommonButton);
    expect(button, findsOneWidget);

    final CommonButton buttonWidget = tester.widget(button);
    expect(buttonWidget.isDisabled, true);
  });
  testWidgets(
      'reset password button is enabled when email text field is filled',
      (WidgetTester tester) async {
    await createWidgetUnderTest(tester);

    // Find text field and enter text
    final Finder textField = find.byType(CommonTextformField);
    await tester.enterText(textField, 'test@example.com');
    await tester.pump(); // Rebuild the widget tree

    // Verify button is enabled
    final Finder button = find.byType(CommonButton);
    final CommonButton buttonWidget = tester.widget(button);
    expect(buttonWidget.isDisabled, false);
  });
}
