import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/common_dialog.dart';
import '../../../../features/authentication/presentation/login_screen/login_widget.dart';
import '../../../../features/routing/app_router.dart';
import '../../domain/auth_status.dart';
import '../../domain/firebase_auth_exception_handler.dart';
import '../../domain/login_form_state.dart';
import 'login_screen_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Future<void> _onLogin() async {
    final AsyncValue<AuthStatus> result = await ref
        .read(loginScreenControllerProvider.notifier)
        .signInWithEmailPassword();

    result.when(
      data: (AuthStatus authStatus) {
        if (authStatus == AuthStatus.successful) {
          if (mounted) {
            context.goNamed(AppRoute.counter.name);
          }
        } else {
          showCommonDialog(
            context: context,
            title: 'Unable to Login',
            content:
                FirebaseAuthExceptionHandler.generateErrorMessage(authStatus),
            primaryButtonText: 'Dismiss',
          );
        }
      },
      error: (Object err, StackTrace stack) {
        showCommonDialog(
          context: context,
          title: 'Error',
          content: 'An unexpected error occurred. Please try again later.',
          primaryButtonText: 'Dismiss',
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginFormState state = ref.watch(loginScreenControllerProvider);

    final LoginScreenController controller =
        ref.read(loginScreenControllerProvider.notifier);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LoginWidget(
            isLoginDisabled: state.isLoginDisabled,
            onLogin: () {
              if (!state.isLoading) {
                _onLogin();
              }
            },
            onEmailChanged: (String value) =>
                setState(() => controller.updateEmail(value)),
            onPasswordChanged: (String value) =>
                setState(() => controller.updatePassword(value)),
            onCreateAccount: () => context.goNamed(AppRoute.signUp.name),
          ),
        ),
      ),
    );
  }
}
