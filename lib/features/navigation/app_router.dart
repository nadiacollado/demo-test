import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/common_widgets/common_scaffold.dart';
import '../authentication/presentation/email_verification/email_verification_screen.dart';
import '../authentication/presentation/forgot_password_screen/forgot_password_screen.dart';
import '../authentication/presentation/login_screen/login_screen.dart';
import '../authentication/presentation/sign_up_screen/sign_up_screen.dart';
import '../counter/presentation/counter_screen.dart';
import '../profile/presentation/edit_user_profile_screen.dart';
import '../profile/presentation/user_profile_screen.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  counter('/counter'),
  login('/auth'),
  signUp('signUp'),
  forgotPassword('forgotPassword'),
  verifyEmail('verifyEmail'),
  profile('/profile'),
  editProfile('editProfile'),
  ;

  const AppRoute(this.path);
  final String path;
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.login.path,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(LoginScreen()),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoute.signUp.path,
            name: AppRoute.signUp.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: CommonScaffold(SignUpScreen()),
            ),
          ),
          GoRoute(
            path: AppRoute.forgotPassword.path,
            name: AppRoute.forgotPassword.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: CommonScaffold(ForgotPasswordScreen()),
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
        ],
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
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CommonScaffold(UserProfileScreen()),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoute.editProfile.path,
            name: AppRoute.editProfile.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: CommonScaffold(EditUserProfileScreen()),
            ),
          ),
        ],
      ),
    ],
  );
}
