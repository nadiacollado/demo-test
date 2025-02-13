import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/login_screen/login_screen_controller.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/authentication/presentation/login_screen/login_widget.dart';
import '../../../../features/routing/app_router.dart';

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
      final result = await ref
          .read(loginScreenControllerProvider.notifier)
          .signInWithEmailPassword(_email, _password);

      result.when(
        data: (_) {
          if (mounted) {
            context.goNamed(AppRoute.counter.name);
          }
        },
        error: (err, stack) {
          print('Login failed: $err');
        },
        loading: () {},
      );
    } else {
      print('Error: Email and password cannot be empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(loginScreenControllerProvider);

    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(
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
                  onEmailChanged: (value) => setState(() => _email = value),
                  onPasswordChanged: (value) =>
                      setState(() => _password = value),
                  onCreateAccount: () => context.goNamed(AppRoute.signUp.name),
                ))));
  }
}
