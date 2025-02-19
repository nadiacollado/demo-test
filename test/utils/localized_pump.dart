import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
  Future<void> localizedPump(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: ProviderScope(child: widget),
      ),
    );
  }

  AppLocalizations get t {
    return AppLocalizationsEn();
  }
}
