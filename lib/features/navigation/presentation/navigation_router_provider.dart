import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common_widgets/common_scaffold.dart';
import '../domain/routes.dart';

part 'navigation_router_provider.g.dart';

List<GoRoute> generateRoutes({bool? noScaffold = false}) {
  List<AppRoutes> rootRoutes = AppRoutes.values.where((route) {
    return route.isRoot;
  }).toList();
  List<GoRoute> routes = rootRoutes.map((route) => route.goRoute()).toList();
  return routes;
}

List<GoRoute> routes = [
  ...generateRoutes(),
];

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return CommonScaffold(
            body: child,
          );
        },
        routes: routes,
      ),
    ],
  );
}
