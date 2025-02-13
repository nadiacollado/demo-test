import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common_widgets/common_text_form_field.dart';
import '../../../../common_widgets/common_button.dart';

class SignUpWidget extends ConsumerStatefulWidget {
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onCreateAccount;
  final VoidCallback onLogin;

  const SignUpWidget(
      {super.key,
      required this.onCreateAccount,
      required this.onEmailChanged,
      required this.onPasswordChanged,
      required this.onLogin});
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
      children: [
        CommonTextformField(
          labelText: 'Email',
          inputHint: 'Please enter your username',
          onChange: widget.onEmailChanged,
        ),
        const SizedBox(height: 16),
        CommonTextformField(
          labelText: 'Password',
          inputHint: 'Please enter your password',
          icon: Icons.lock,
          obscureText: true,
          onChange: widget.onPasswordChanged,
        ),
        const SizedBox(height: 16),
        CommonTextformField(
          labelText: 'Confirm Password',
          inputHint: 'Please reenter your password',
          icon: Icons.lock,
          obscureText: true,
          onChange: widget.onPasswordChanged,
        ),
        const SizedBox(height: 16),
        CommonButton(
          text: "Create Account",
          onPressed: () => widget.onCreateAccount,
          type: ButtonType.primary,
          isFullWidth: true,
        ),
        const SizedBox(height: 16), // Space between buttons
        CommonButton(
          text: "Have an Account? Login",
          onPressed: widget.onLogin,
          type: ButtonType.transparent,
          isFullWidth: true,
        ),
      ],
    );
  }
}
