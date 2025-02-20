import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../common_widgets/common_text_form_field.dart';
import '../../../../l10n/translate.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({
    super.key,
    required this.onLogin,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onCreateAccount,
    this.isLoginDisabled = false,
  });

  final void Function() onLogin;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final bool isLoginDisabled;
  final VoidCallback onCreateAccount;

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
        CommonButton(
          text: context.t.auth_login,
          isDisabled: widget.isLoginDisabled,
          onPressed: widget.onLogin,
          isFullWidth: true,
        ),
        CommonButton(
          text: context.t.auth_createAnAccount,
          onPressed: widget.onCreateAccount,
          type: ButtonType.transparent,
          isFullWidth: true,
        ),
      ],
    );
  }
}
