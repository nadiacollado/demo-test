import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/common_dialog.dart';
import '../../../../features/authentication/presentation/sign_up_screen/sign_up_widget.dart';
import '../../../../features/routing/app_router.dart';
import '../../../../l10n/translate.dart';
import '../../domain/auth_status.dart';
import '../../domain/firebase_auth_exception_handler.dart';
import '../../domain/sign_up_form_state.dart';
import 'sign_up_screen_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUpScreen> {
  Future<void> _onSignUp() async {
    final AsyncValue<AuthStatus> result = await ref
        .read(signUpScreenControllerProvider.notifier)
        .signUpWithEmailPassword();

    result.when(
      data: (AuthStatus authStatus) {
        if (authStatus == AuthStatus.emailNotVerified ||
            authStatus == AuthStatus.successful) {
          if (mounted) {
            context.goNamed(AppRoute.verifyEmail.name);
          }
        } else {
          showCommonDialog(
            context: context,
            title: context.t.auth_unableToCreateAccount,
            content:
                FirebaseAuthExceptionHandler.generateErrorMessage(authStatus),
            primaryButtonText: 'Dismiss',
          );
        }
      },
      error: (Object err, StackTrace stack) {
        showCommonDialog(
          context: context,
          title: context.t.auth_unableToCreateAccount,
          content: 'Unexpected Error',
          primaryButtonText: 'Dismiss',
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final SignUpFormState state = ref.watch(signUpScreenControllerProvider);
    final SignUpScreenController controller =
        ref.read(signUpScreenControllerProvider.notifier);

    return Center(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SignUpWidget(
            isCreateAccountDisabled: state.isSignUpDisabled,
            onCreateAccount: () {
              if (!state.isLoading) {
                _onSignUp();
              }
            },
            onEmailChanged: (String value) =>
                setState(() => controller.updateEmail(value)),
            onPasswordChanged: (String value) =>
                setState(() => controller.updatePassword(value)),
            onConfirmedPasswordChanged: (String value) =>
                setState(() => controller.updateConfirmPassword(value)),
            onLogin: () => context.goNamed(AppRoute.login.name),
          ),
        ),
      ),
    );
  }
}
