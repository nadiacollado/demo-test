import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/authentication/presentation/sign_up_screen/sign_up_widget.dart';
import '../../../../features/routing/app_router.dart';
import 'sign_up_screen_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUpScreen> {
  String _email = '';
  String _password = '';

  Future<void> _onSignUp() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      await ref
          .read(signUpScreenControllerProvider.notifier)
          .signUpWithEmailPassword(_email, _password);
    }

    if (mounted) {
      context.goNamed(AppRoute.login.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(signUpScreenControllerProvider);

    return Center(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SignUpWidget(
            onCreateAccount: () {
              if (!state.isLoading) {
                _onSignUp();
              }
            },
            onEmailChanged: (String value) => setState(() => _email = value),
            onPasswordChanged: (String value) =>
                setState(() => _password = value),
            onLogin: () => context.goNamed(AppRoute.login.name),
          ),
        ),
      ),
    );
  }
}
