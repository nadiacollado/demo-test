import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../common_widgets/common_text_form_field.dart';
import '../../data/firebase_auth_repository.dart';
import '../../domain/forgot_password_form_state.dart';
import 'forgot_password_screen_controller.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ForgotPasswordFormState state =
        ref.watch(forgotPasswordScreenControllerProvider);
    final ForgotPasswordScreenController controller =
        ref.read(forgotPasswordScreenControllerProvider.notifier);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: <Widget>[
            const Text('Forgot Your Password?'),
            CommonTextformField(
              inputHint: 'Enter email',
              onChange: controller.updateEmail,
              labelText: 'Email',
            ),
            CommonButton(
              text: 'Reset Password',
              onPressed: () => controller.resetPasswordWithEmail(state.email),
              isFullWidth: true,
              isDisabled: state.isResetPasswordDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
