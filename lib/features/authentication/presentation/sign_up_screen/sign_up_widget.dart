import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../common_widgets/common_text_form_field.dart';
import '../../../../l10n/translate.dart';

class SignUpWidget extends ConsumerStatefulWidget {
  const SignUpWidget({
    super.key,
    required this.onCreateAccount,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmedPasswordChanged,
    required this.onLogin,
    this.isCreateAccountDisabled = false,
  });

  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmedPasswordChanged;
  final void Function() onCreateAccount;
  final bool isCreateAccountDisabled;

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
          labelText: context.t.auth_email,
          inputHint: context.t.auth_enterEmail,
          icon: Icons.email,
          onChange: widget.onEmailChanged,
        ),
        CommonTextformField(
          labelText: context.t.auth_password,
          inputHint: context.t.auth_enterPassword,
          icon: Icons.lock,
          obscureText: true,
          onChange: widget.onPasswordChanged,
        ),
        CommonTextformField(
          labelText: context.t.auth_confirmPassword,
          inputHint: context.t.auth_reenterPassword,
          icon: Icons.lock,
          obscureText: true,
          onChange: widget.onConfirmedPasswordChanged,
        ),
        CommonButton(
          text: context.t.auth_createAccount,
          isDisabled: widget.isCreateAccountDisabled,
          onPressed: widget.onCreateAccount,
          isFullWidth: true,
        ),
        CommonButton(
          text: context.t.auth_haveAccountLogin,
          onPressed: widget.onLogin,
          type: ButtonType.transparent,
          isFullWidth: true,
        ),
      ],
    );
  }
}
