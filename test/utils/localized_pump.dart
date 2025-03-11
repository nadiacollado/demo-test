import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/navigation/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'test_router.dart';

const List<LocalizationsDelegate<Object>> delegates =
    <LocalizationsDelegate<Object>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

extension LocalizedPump on WidgetTester {
  /// Pumps the given widget within a [MaterialApp] that is
  /// properly configured for localizations.
  ///
  /// The locale is set to English, and the supported locales are
  /// set to the locales supported by the app.
  ///
  /// The [ProviderScope] is also added to the widget tree.
  ///
  /// This is useful for testing widgets that use localizations
  /// and/or Riverpod's [ProviderScope].
  ///
  /// You can also use the [t] getter to access the localized
  /// strings in the test.

  Future<void> localizedPump(
    Widget widget, {
    List<Override> overrides = const <Override>[],
    bool useRouter = false,
    String initialLocation = '/auth',
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: <Override>[
          if (useRouter)
            goRouterProvider.overrideWith(
              (Ref<GoRouter> ref) =>
                  ref.watch(testRouterProvider(initialLocation)),
            ),
          ...overrides,
        ],
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, _) {
            return useRouter
                ? MaterialApp.router(
                    routerConfig: ref.read(testRouterProvider(initialLocation)),
                    localizationsDelegates: delegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: const Locale('en'),
                  )
                : MaterialApp(
                    home: Scaffold(body: widget),
                    localizationsDelegates: delegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: const Locale('en'),
                  );
          },
        ),
      ),
    );
  }

  AppLocalizations get t {
    return AppLocalizationsEn();
  }
}
