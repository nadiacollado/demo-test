import 'package:flutter/material.dart';

import '../../counter/presentation/counter_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  home(
    path: '/',
    page: CounterScreen(),
    children: [],
  );

  const AppRoutes({
    required this.path,
    required this.page,
    this.children,
  });

  final String path;
  final Widget page;
  final List<AppRoutes>? children;

  GoRoute goRoute({String? overridePath}) {
    return GoRoute(
      path: overridePath ?? path,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
      },
      routes: children?.map((route) => route.goRoute()).toList() ?? [],
    );
  }

  bool get isChild => !path.startsWith('/');
  bool get isRoot => path.startsWith('/');
  bool get hasChildren => children != null;
}
