import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common_widgets/common_dialog.dart';
import '../../../../features/authentication/presentation/login_screen/login_widget.dart';
import '../../../../l10n/translate.dart';
import '../../../navigation/app_router.dart';
import '../../application/auth_state_notifier.dart';
import '../../domain/auth_state.dart';
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
  Future<void> _onLogin(LoginScreenController controller) async {
    await controller.signInWithEmailPassword();
    if (!mounted) return;

    final AsyncValue<AuthState> authState = ref.read(authStateNotifierProvider);
    authState.when(
      data: (AuthState authState) {
        if (authState.status == AuthStatus.authenticated) {
          if (mounted) {
            context.goNamed(AppRoute.profile.name);
          }
        } else if (authState.status == AuthStatus.emailNotVerified) {
          context.push(AppRoute.verifyEmail.path);
        } else {
          showCommonDialog(
            context: context,
            title: context.t.auth_unableToLogin,
            content: FirebaseAuthExceptionHandler.generateErrorMessage(
              authState.status,
            ),
            primaryButtonText: context.t.dialog_dismiss,
          );
        }
      },
      error: (Object err, StackTrace stack) {
        showCommonDialog(
          context: context,
          title: context.t.global_genericErrorTitle,
          content: context.t.profile_errorMessage,
          primaryButtonText: context.t.dialog_dismiss,
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthState> authState =
        ref.watch(authStateNotifierProvider);
    final LoginFormState state = ref.watch(loginScreenControllerProvider);
    final LoginScreenController controller =
        ref.read(loginScreenControllerProvider.notifier);

    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LoginWidget(
              isLoginDisabled: state.isLoginDisabled,
              onLogin: () {
                if (!state.isLoading) {
                  _onLogin(controller);
                }
              },
              onEmailChanged: (String value) =>
                  setState(() => controller.updateEmail(value)),
              onPasswordChanged: (String value) =>
                  setState(() => controller.updatePassword(value)),
              onCreateAccount: () => context.goNamed(AppRoute.signUp.name),
              onForgotPassword: () =>
                  context.pushNamed(AppRoute.forgotPassword.name),
            ),
          ),
        ),
        if (authState.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
