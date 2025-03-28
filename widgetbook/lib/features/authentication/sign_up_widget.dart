import 'package:flutter/material.dart';
import 'package:demo_test/widgets.dart' show SignUpWidget;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Sign Up Widget',
  type: SignUpWidget,
)
Widget useCaseSignUpWidget(BuildContext context) {
  return SignUpWidget(
    onCreateAccount: () {},
    onEmailChanged: (email) {},
    onPasswordChanged: (password) {},
    onConfirmedPasswordChanged: (confirmedPassword) {},
    onLogin: () {},
    isCreateAccountDisabled: context.knobs
        .boolean(label: 'Disable Create Account', initialValue: false),
  );
}
