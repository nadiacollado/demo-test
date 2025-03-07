import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/translate.dart';
import '../../authentication/application/auth_state_notifier.dart';
import '../app_router.dart';
import 'nav_drawer_item.dart';

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
              NavDrawerItem(
                icon: Icons.home,
                title: context.t.nav_home,
                onTap: () => <void>{
                  Navigator.pop(context),
                  context.goNamed(AppRoute.profile.name),
                },
              ),
              NavDrawerItem(
                icon: Icons.dynamic_form_outlined,
                title: context.t.nav_editProfile,
                onTap: () => <void>{
                  Navigator.pop(context),
                  context.goNamed(AppRoute.editProfile.name),
                },
              ),
              NavDrawerItem(
                icon: Icons.logout,
                title: context.t.nav_logout,
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
