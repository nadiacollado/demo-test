import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/common_widgets/common_scaffold.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_screen.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/login_screen/login_screen.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:flutter_starter_kit/features/counter/presentation/counter_screen.dart';
import 'package:flutter_starter_kit/features/routing/app_router.dart';
import 'package:go_router/go_router.dart';

final ProviderFamily<GoRouter, String> testRouterProvider =
    Provider.family<GoRouter, String>(
        (Ref<GoRouter> ref, String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(body: LoginScreen()),
        ),
      ),
      GoRoute(
        path: '/signUp',
        name: 'signUp',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(body: SignUpScreen()),
        ),
      ),
      GoRoute(
        path: '/counter',
        name: 'counter',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(body: CounterScreen()),
        ),
      ),
      GoRoute(
        path: '/verifyEmail',
        name: AppRoute.verifyEmail.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(body: EmailVerificationScreen()),
        ),
      ),
    ],
  );
});
