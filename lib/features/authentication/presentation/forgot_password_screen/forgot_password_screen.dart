import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../common_widgets/common_dialog.dart';
import '../../../../common_widgets/common_text_form_field.dart';
import '../../../../l10n/translate.dart';
import '../../domain/auth_status.dart';
import '../../domain/firebase_auth_exception_handler.dart';
import '../../domain/forgot_password_form_state.dart';
import 'forgot_password_screen_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends ConsumerState<ForgotPasswordScreen> {
  Future<void> _onForgotPassword() async {
    final AsyncValue<AuthStatus> result = await ref
        .read(forgotPasswordScreenControllerProvider.notifier)
        .resetPasswordWithEmail();
    result.when(
      data: (AuthStatus authStatus) {
        if (authStatus == AuthStatus.successful) {
          showCommonDialog(
            context: context,
            title: context.t.global_emailSent,
            content: context.t.auth_forgotPasswordEmail,
            primaryButtonText: context.t.dialog_dismiss,
            onDismissal: () {
              context.pop();
            },
          );
        } else {
          showCommonDialog(
            context: context,
            title: context.t.auth_unableToResetPassword,
            content:
                FirebaseAuthExceptionHandler.generateErrorMessage(authStatus),
            primaryButtonText: context.t.dialog_dismiss,
          );
        }
      },
      error: (Object err, StackTrace stack) {
        showCommonDialog(
          context: context,
          title: context.t.auth_unableToResetPassword,
          content: context.t.global_genericErrorMessage,
          primaryButtonText: context.t.dialog_dismiss,
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              context.t.auth_forgotPassword,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CommonTextformField(
              inputHint: context.t.auth_enterEmail,
              onChange: controller.updateEmail,
              labelText: context.t.auth_email,
            ),
            CommonButton(
              text: context.t.auth_resetPassword,
              onPressed: () => _onForgotPassword(),
              isFullWidth: true,
              isDisabled: state.isResetPasswordDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
