import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widgets/common_dialog.dart';
import '../../../../core/common_widgets/common_public_scaffold.dart';
import '../../../../l10n/translate.dart';
import '../../domain/auth_status.dart';
import '../../domain/firebase_auth_exception_handler.dart';
import 'email_verification_screen_controller.dart';
import 'email_verification_widget.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EmailVerificationScreenController controller =
        ref.watch(emailVerificationScreenControllerProvider.notifier);

    return CommonPublicScaffold(
      Center(
        child: EmailVerificationWidget(
          onSendEmail: () async {
            final AsyncValue<AuthStatus> result =
                await controller.sendVerificationEmailAddress();
            result.when(
              data: (AuthStatus authStatus) {
                if (authStatus == AuthStatus.successful) {
                  showCommonDialog(
                    context: context,
                    title: context.t.global_emailSent,
                    content: context.t.auth_verification_email_sent,
                    primaryButtonText: context.t.dialog_dismiss,
                  );
                } else {
                  showCommonDialog(
                    context: context,
                    title: context.t.global_genericErrorMessage,
                    content: FirebaseAuthExceptionHandler.generateErrorMessage(
                      authStatus,
                    ),
                    primaryButtonText: context.t.dialog_dismiss,
                  );
                }
              },
              loading: () {},
              error: (Object err, StackTrace stack) {},
            );
          },
        ),
      ),
    );
  }
}
