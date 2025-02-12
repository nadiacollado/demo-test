import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/sign_up_screen/sign_up_widget.dart';
import 'package:flutter_starter_kit/features/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: 600,
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SignUpWidget(
                  onCreateAccount: () => {},
                  onEmailChanged: (value) => {},
                  onPasswordChanged: (value) => {},
                  onLogin: () => context.goNamed(AppRoute.login.name),
                ))));
  }
}
