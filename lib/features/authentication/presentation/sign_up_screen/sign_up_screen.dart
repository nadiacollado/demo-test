import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/sign_up_screen/sign_up_screen_controller.dart';
import '../../../../common_widgets/common_dialog.dart';
import '../../../../features/authentication/presentation/sign_up_screen/sign_up_widget.dart';
import '../../../../features/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUpScreen> {
  Future<void> _onSignUp() async {
    final result = await ref
        .read(signUpScreenControllerProvider.notifier)
        .signUpWithEmailPassword();

    result.when(
      data: (_) {
        if (mounted) {
          context.goNamed(AppRoute.login.name);
        }
      },
      error: (err, stack) {
        showCommonDialog(
          context: context,
          title: 'Unable to Create Account',
          content: 'Email is invalid',
          primaryButtonText: 'Dismiss',
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(signUpScreenControllerProvider);
    final controller = ref.read(signUpScreenControllerProvider.notifier);

    return Center(
        child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SignUpWidget(
                  isCreateAccountDisabled: controller.isSignUpDisabled,
                  onCreateAccount: () {
                    if (!state.isLoading) {
                      _onSignUp();
                    }
                  },
                  onEmailChanged: (value) =>
                      setState(() => controller.updateEmail(value)),
                  onPasswordChanged: (value) =>
                      setState(() => controller.updatePassword(value)),
                  onConfirmedPasswordChanged: (value) =>
                      setState(() => controller.updateConfirmPassword(value)),
                  onLogin: () => context.goNamed(AppRoute.login.name),
                ))));
  }
}
