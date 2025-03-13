import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../authentication/application/auth_state_notifier.dart';
import '../authentication/domain/auth_state.dart';
import '../authentication/domain/auth_status.dart';
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
  verifyEmail('/verifyEmail'),
  profile('/profile'),
  editProfile('editProfile'),
  ;

  const AppRoute(this.path);
  final String path;
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final AsyncValue<AuthState> authState = ref.watch(authStateNotifierProvider);
  return GoRouter(
    initialLocation: AppRoute.login.path,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: LoginScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoute.signUp.path,
            name: AppRoute.signUp.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: SignUpScreen(),
            ),
          ),
          GoRoute(
            path: AppRoute.forgotPassword.path,
            name: AppRoute.forgotPassword.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: ForgotPasswordScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.verifyEmail.path,
        name: AppRoute.verifyEmail.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: EmailVerificationScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.counter.path,
        name: AppRoute.counter.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: CounterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            const NoTransitionPage<dynamic>(
          child: UserProfileScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoute.editProfile.path,
            name: AppRoute.editProfile.name,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                const NoTransitionPage<dynamic>(
              child: EditUserProfileScreen(),
            ),
          ),
        ],
      ),
    ],
    // ignore: body_might_complete_normally_nullable
    redirect: (BuildContext context, GoRouterState state) {
      final String? pathToRedirect = authState.when(
        data: (AuthState authState) {
          if (authState.status == AuthStatus.authenticated) {
            if (state.uri.path == AppRoute.login.path ||
                state.uri.path == AppRoute.signUp.path) {
              return AppRoute.profile.path;
            }
          }
          if (authState.status == AuthStatus.emailNotVerified) {
            if (state.uri.path != AppRoute.verifyEmail.path) {
              return AppRoute.verifyEmail.path;
            }
          }
          return null;
        },
        error: (Object error, StackTrace stack) {
          return null;
        },
        loading: () {
          return null;
        },
      );
      if (pathToRedirect != null) return pathToRedirect;
    },
  );
}
