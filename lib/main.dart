import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/routing/app_router.dart';
import 'firebase_options.dart';
import 'l10n/translate.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  static const MaterialColor primaryColor = Colors.blue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      onGenerateTitle: (BuildContext context) => context.t.global_title,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 'en' is the language code. We could optionally provide a country code as the second param,
      // e.g. Locale('en', 'US'). If we do that, we may want to provide an additional app_en_US.arb
      // file for region-specific translations. Any locale with a country code should have one
      // without as a fallback, so with Locale('en', 'US') we should also have Locale('en', '')
      supportedLocales: const <Locale>[
        Locale('en', ''),
        // Locales added here should be added to ios/Runner/Info.plist as well, in the
        // CFBundleLocalizations array.
      ],
      theme: ThemeData(
        colorSchemeSeed: primaryColor,
        unselectedWidgetColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2.0,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
    );
  }
}
