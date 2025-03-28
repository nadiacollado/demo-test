import 'package:flutter/material.dart';
import 'package:demo_test/widgets.dart' show LoginWidget;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Login Widget',
  type: LoginWidget,
)
Widget useCaseLoginWidget(BuildContext context) {
  return LoginWidget(
    onLogin: () {},
    onEmailChanged: (email) {},
    onPasswordChanged: (password) {},
    onCreateAccount: () {},
    onForgotPassword: () {},
    isLoginDisabled:
        context.knobs.boolean(label: 'Disable Login', initialValue: false),
  );
}
