import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widgets/common_full_width.dart';
import '../../../../core/common_widgets/common_text_form_field.dart';
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
    this.doPasswordsMatch = false,
  });

  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmedPasswordChanged;
  final void Function() onCreateAccount;
  final bool isCreateAccountDisabled;
  final bool doPasswordsMatch;

  final VoidCallback onLogin;

  @override
  ConsumerState<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bool enabled = !widget.isCreateAccountDisabled;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          CommonTextFormField(
            labelText: context.t.auth_confirmPassword,
            inputHint: context.t.auth_reenterPassword,
            icon: Icons.lock,
            obscureText: true,
            onChange: widget.onConfirmedPasswordChanged,
            validator: _validatePassword,
          ),
          CommonFullWidth(
            child: FilledButton(
              onPressed: enabled ? widget.onCreateAccount : null,
              child: Text(context.t.auth_createAccount),
            ),
          ),
          CommonFullWidth(
            child: TextButton(
              onPressed: widget.onLogin,
              child: Text(context.t.auth_haveAccountLogin),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return context.t.auth_emailErrorMessage;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 5) {
      return context.t.auth_passwordErrorMessage;
    } else if (widget.doPasswordsMatch) {
      return context.t.auth_passwordMatchErrorMessage;
    }
    return null;
  }
}
