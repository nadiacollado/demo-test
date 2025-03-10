import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/common_widgets/common_scaffold.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_screen.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/login_screen/login_screen.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:flutter_starter_kit/features/counter/presentation/counter_screen.dart';
import 'package:flutter_starter_kit/features/navigation/app_router.dart';
import 'package:flutter_starter_kit/features/profile/presentation/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

final ProviderFamily<GoRouter, String> testRouterProvider =
    Provider.family<GoRouter, String>(
        (Ref<GoRouter> ref, String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(LoginScreen()),
        ),
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        name: AppRoute.signUp.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(SignUpScreen()),
        ),
      ),
      GoRoute(
        path: AppRoute.counter.path,
        name: AppRoute.counter.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(CounterScreen()),
        ),
      ),
      GoRoute(
        path: AppRoute.verifyEmail.path,
        name: AppRoute.verifyEmail.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(EmailVerificationScreen()),
        ),
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(UserProfileScreen()),
        ),
      ),
    ],
  );
});
