import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/translate.dart';
import '../../authentication/application/auth_state_notifier.dart';
import '../app_router.dart';

class NavDrawer extends ConsumerWidget {
  const NavDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthStateNotifier authNotifier =
        ref.watch(authStateNotifierProvider.notifier);

    return Stack(
      children: <Widget>[
        Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                ),
                child: Center(
                  child: Text(
                    context.t.nav_headerTitle.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: Text(
                  context.t.nav_home.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  context.goNamed(AppRoute.profile.name);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dynamic_form_outlined),
                title: Text(
                  context.t.nav_editProfile.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  context.goNamed(AppRoute.editProfile.name);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  context.t.nav_logout.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onTap: () async {
                  await authNotifier.signOut();

                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 30,
          right: 5,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
