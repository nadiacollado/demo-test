import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common_widgets/common_scaffold.dart';
import '../../features/authentication/presentation/login_screen/login_screen.dart';
import '../../features/authentication/presentation/sign_up_screen/sign_up_screen.dart';
import '../authentication/presentation/email_verification/email_verification_screen.dart';
import '../authentication/presentation/forgot_password_screen/forgot_password_screen.dart';
import '../counter/presentation/counter_screen.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute { counter, login, signUp, forgotPassword, verifyEmail }

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(LoginScreen()),
        ),
      ),
      GoRoute(
        path: '/signUp',
        name: AppRoute.signUp.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(SignUpScreen()),
        ),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: AppRoute.forgotPassword.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(ForgotPasswordScreen()),
        ),
      ),
      GoRoute(
        path: '/verifyEmail',
        name: AppRoute.verifyEmail.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(EmailVerificationScreen()),
        ),
      ),
      GoRoute(
        path: '/counter',
        name: AppRoute.counter.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(CounterScreen()),
        ),
      ),
    ],
  );
}
