import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme_controller.dart';
import '../l10n/translate.dart';

class CommonScaffold extends ConsumerWidget {
  const CommonScaffold(
    this.body, {
    super.key,
    this.title,
  });

  final String? title;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? context.t.global_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              switch (themeMode) {
                ThemeMode.light => Icons.dark_mode,
                ThemeMode.dark => Icons.brightness_auto,
                ThemeMode.system => Icons.light_mode,
              },
            ),
            onPressed: () {
              ref.read(themeControllerProvider.notifier).toggleTheme();
            },
            tooltip: switch (themeMode) {
              ThemeMode.light => 'Switch to dark mode',
              ThemeMode.dark => 'Switch to system mode',
              ThemeMode.system => 'Switch to light mode',
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
