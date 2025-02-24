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
    required this.onForgotPassword,
    this.isLoginDisabled = false,
  });

  final void Function() onLogin;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final bool isLoginDisabled;
  final VoidCallback onCreateAccount;
  final VoidCallback onForgotPassword;

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: <Widget>[
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
              CommonButton(
                text: context.t.auth_login,
                isDisabled: widget.isLoginDisabled,
                onPressed: widget.onLogin,
                isFullWidth: true,
              ),
              CommonButton(
                text: context.t.auth_forgotPassword,
                type: ButtonType.transparent,
                onPressed: widget.onForgotPassword,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: CommonButton(
              text: context.t.auth_createAnAccount,
              onPressed: widget.onCreateAccount,
              type: ButtonType.transparent,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
