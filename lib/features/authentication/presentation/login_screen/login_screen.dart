import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/authentication/presentation/login_screen/login_widget.dart';
import '../../../../features/routing/app_router.dart';
import 'login_screen_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _email = '';
  String _password = '';

  Future<void> _onLogin() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      final AsyncValue<void> result = await ref
          .read(loginScreenControllerProvider.notifier)
          .signInWithEmailPassword(_email, _password);

      result.when(
        data: (_) {
          if (mounted) {
            context.goNamed(AppRoute.counter.name);
          }
        },
        error: (Object err, StackTrace stack) {
          // ignore: avoid_print
          print('Login failed: $err');
        },
        loading: () {},
      );
    } else {
      // ignore: avoid_print
      print('Error: Email and password cannot be empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(loginScreenControllerProvider);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LoginWidget(
            onLogin: () {
              if (!state.isLoading) {
                _onLogin();
              }
            },
            onEmailChanged: (String value) => setState(() => _email = value),
            onPasswordChanged: (String value) =>
                setState(() => _password = value),
            onCreateAccount: () => context.goNamed(AppRoute.signUp.name),
          ),
        ),
      ),
    );
  }
}
