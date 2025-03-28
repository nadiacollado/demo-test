import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:demo_test/l10n/arb/app_localizations.dart';
import 'package:demo_test/core/theme/app_theme.dart';
import 'package:demo_test/core/theme/theme_controller.dart';

import 'main.directories.g.dart';

void main() {
  runApp(ProviderScope(child: const WidgetbookApp()));
}

@widgetbook.App()
class WidgetbookApp extends ConsumerWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeControllerProvider);
    return Widgetbook.material(
      directories: directories,
      addons: [
        LocalizationAddon(
          locales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          initialLocale: AppLocalizations.supportedLocales.last,
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light Theme',
              data: AppTheme.light,
            ),
            WidgetbookTheme(
              name: 'Dark Theme',
              data: AppTheme.dark,
            ),
          ],
        ),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13Mini,
            Devices.ios.iPhone13,
            Devices.ios.iPhone13ProMax,
            Devices.android.smallPhone,
            Devices.android.mediumPhone,
            Devices.android.bigPhone,
          ],
        ),
      ],
      themeMode: themeMode,
    );
  }
}
