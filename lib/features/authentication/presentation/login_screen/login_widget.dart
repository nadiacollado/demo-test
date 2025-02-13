import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../common_widgets/common_text_form_field.dart';

class LoginWidget extends ConsumerStatefulWidget {
  final void Function() onLogin;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onCreateAccount;

  const LoginWidget({
    super.key,
    required this.onLogin,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onCreateAccount,
  });
  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.0,
      children: [
        CommonTextformField(
          labelText: 'Email',
          inputHint: 'Please enter your email',
          onChange: widget.onEmailChanged,
        ),
        CommonTextformField(
          labelText: 'Password',
          inputHint: 'Please enter your password',
          icon: Icons.lock,
          obscureText: true,
          onChange: widget.onPasswordChanged,
        ),
        CommonButton(
          text: "Login",
          onPressed: widget.onLogin,
          type: ButtonType.primary,
          isFullWidth: true,
        ),
        CommonButton(
          text: "Create an Account",
          onPressed: widget.onCreateAccount,
          type: ButtonType.transparent,
          isFullWidth: true,
        ),
      ],
    );
  }
}
