import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/primary_button.dart';

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
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Please enter your username',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          onChanged: widget.onEmailChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Please enter your password',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: widget.onPasswordChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Please reenter your password',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: widget.onPasswordChanged,
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          text: "Create Account",
          onPressed: () => widget.onCreateAccount,
          type: ButtonType.primary,
          isFullWidth: true,
        ),
        const SizedBox(height: 16), // Space between buttons
        PrimaryButton(
          text: "Have an Account? Login",
          onPressed: widget.onLogin,
          type: ButtonType.transparent,
          isFullWidth: true,
        ),
      ],
    );
  }
}
