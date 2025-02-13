import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/counter/presentation/counter_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../common_widgets/common_scaffold.dart';
import '../../features/authentication/presentation/login_screen/login_screen.dart';
import '../../features/authentication/presentation/sign_up_screen/sign_up_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute { counter, login, signUp }

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
      initialLocation: '/login',
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: '/login',
          name: AppRoute.login.name,
          pageBuilder: (context, state) => const NoTransitionPage(
              child: CommonScaffold(body: LoginScreen())),
        ),
        GoRoute(
          path: '/signUp',
          name: AppRoute.signUp.name,
          pageBuilder: (context, state) => const NoTransitionPage(
              child: CommonScaffold(body: SignUpScreen())),
        ),
        GoRoute(
          path: '/counter',
          name: AppRoute.counter.name,
          pageBuilder: (context, state) => const NoTransitionPage(
              child: CommonScaffold(body: CounterScreen())),
        ),
      ]);
}
