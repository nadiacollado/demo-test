import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widgets/common_full_width.dart';
import '../../../../core/common_widgets/common_text_form_field.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool enabled = !widget.isLoginDisabled;
    return SizedBox.expand(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: <Widget>[
                CommonTextFormField(
                  labelText: context.t.auth_email,
                  inputHint: context.t.auth_enterEmail,
                  icon: Icons.email,
                  onChange: widget.onEmailChanged,
                  validator: _validateEmail,
                ),
                CommonTextFormField(
                  labelText: context.t.auth_password,
                  inputHint: context.t.auth_enterPassword,
                  icon: Icons.lock,
                  obscureText: true,
                  onChange: widget.onPasswordChanged,
                  validator: _validatePassword,
                ),
                CommonFullWidth(
                  child: FilledButton(
                    onPressed: enabled
                        ? () {
                            if (_formKey.currentState?.validate() ?? false) {
                              widget.onLogin();
                            }
                          }
                        : null,
                    child: Text(context.t.auth_login),
                  ),
                ),
                TextButton(
                  onPressed: widget.onForgotPassword,
                  child: Text(context.t.auth_forgotPassword),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: CommonFullWidth(
                child: TextButton(
                  onPressed: widget.onCreateAccount,
                  child: Text(context.t.auth_createAnAccount),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.t.auth_enterEmail;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return context.t.auth_emailErrorMessage;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.t.auth_enterPassword;
    } else if (value.length < 5) {
      return context.t.auth_passwordErrorMessage;
    }
    return null;
  }
}
