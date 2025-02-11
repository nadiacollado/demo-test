import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/common_widgets/common_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../counter/presentation/counter_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute { counter }

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(navigatorKey: _rootNavigatorKey, routes: [
    GoRoute(
      path: '/',
      name: AppRoute.counter.name,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: CommonScaffold(body: CounterScreen())),
    ),
  ]);
}
