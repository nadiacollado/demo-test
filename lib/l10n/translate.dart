import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Provides a convenient way to access localized strings within the app.
///
/// This extension on [BuildContext] allows you to easily retrieve the
/// [AppLocalizations] instance for the current locale, making it simple to
/// access translated text throughout the app anywhere there is a [BuildContext].
///
/// Usage:
/// ```dart
/// final String appTitle = context.t.global_title;
/// ```
extension Translate on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this)!;
}
