import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../common_widgets/common_text_form_field.dart';

class SignUpWidget extends ConsumerStatefulWidget {
  const SignUpWidget({
    super.key,
    required this.onCreateAccount,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onLogin,
  });

  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final void Function() onCreateAccount;
  final VoidCallback onLogin;

  @override
  ConsumerState<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: <Widget>[
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
        CommonTextformField(
          labelText: 'Confirm Password',
          inputHint: 'Please reenter your password',
          icon: Icons.lock,
          obscureText: true,
          onChange: widget.onPasswordChanged,
        ),
        CommonButton(
          text: 'Create Account',
          onPressed: widget.onCreateAccount,
          isFullWidth: true,
        ),
        CommonButton(
          text: 'Have an Account? Login',
          onPressed: widget.onLogin,
          type: ButtonType.transparent,
          isFullWidth: true,
        ),
      ],
    );
  }
}
