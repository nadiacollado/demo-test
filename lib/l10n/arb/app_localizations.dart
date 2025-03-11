import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The title of the app
  ///
  /// In en, this message translates to:
  /// **'RetroSpace'**
  String get global_title;

  /// No description provided for @global_genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try again Later'**
  String get global_genericErrorMessage;

  /// No description provided for @global_genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unexpected Error'**
  String get global_genericErrorTitle;

  /// No description provided for @global_emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get global_emailSent;

  /// No description provided for @global_having_trouble.
  ///
  /// In en, this message translates to:
  /// **'Having Trouble?'**
  String get global_having_trouble;

  /// No description provided for @auth_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// No description provided for @auth_enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get auth_enterEmail;

  /// No description provided for @auth_resend_email.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get auth_resend_email;

  /// No description provided for @auth_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// No description provided for @auth_enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get auth_enterPassword;

  /// No description provided for @auth_confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_confirmPassword;

  /// No description provided for @auth_reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please reenter your password'**
  String get auth_reenterPassword;

  /// No description provided for @auth_unableToResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Unable to Reset Password'**
  String get auth_unableToResetPassword;

  /// No description provided for @auth_resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_resetPassword;

  /// No description provided for @auth_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get auth_forgotPassword;

  /// No description provided for @auth_forgotPasswordEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email to reset your password'**
  String get auth_forgotPasswordEmail;

  /// No description provided for @auth_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login;

  /// No description provided for @auth_createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get auth_createAnAccount;

  /// No description provided for @auth_createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_createAccount;

  /// No description provided for @auth_haveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Have an account? Login'**
  String get auth_haveAccountLogin;

  /// No description provided for @auth_unableToLogin.
  ///
  /// In en, this message translates to:
  /// **'Unable to log in'**
  String get auth_unableToLogin;

  /// No description provided for @auth_unableToCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Unable to Create Account'**
  String get auth_unableToCreateAccount;

  /// No description provided for @auth_please_verify_email.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address. A confirmation link has been sent to your email. Once verified, sign in again to continue.'**
  String get auth_please_verify_email;

  /// No description provided for @auth_verification_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Verification email has been sent'**
  String get auth_verification_email_sent;

  /// No description provided for @auth_emailErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get auth_emailErrorMessage;

  /// No description provided for @auth_passwordErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 5 characters long'**
  String get auth_passwordErrorMessage;

  /// No description provided for @auth_passwordMatchErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get auth_passwordMatchErrorMessage;

  /// No description provided for @dialog_dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dialog_dismiss;

  /// No description provided for @count_counter.
  ///
  /// In en, this message translates to:
  /// **'Counter: {counter}'**
  String count_counter(int counter);

  /// No description provided for @profile_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profile_username;

  /// No description provided for @profile_firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get profile_firstName;

  /// No description provided for @profile_lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get profile_lastName;

  /// No description provided for @profile_pronouns.
  ///
  /// In en, this message translates to:
  /// **'Pronouns'**
  String get profile_pronouns;

  /// No description provided for @profile_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profile_age;

  /// No description provided for @profile_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profile_location;

  /// No description provided for @profile_bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profile_bio;

  /// No description provided for @profile_editUsername.
  ///
  /// In en, this message translates to:
  /// **'Edit Username'**
  String get profile_editUsername;

  /// No description provided for @profile_editFirstName.
  ///
  /// In en, this message translates to:
  /// **'Edit First Name'**
  String get profile_editFirstName;

  /// No description provided for @profile_editLastName.
  ///
  /// In en, this message translates to:
  /// **'Edit Last Name'**
  String get profile_editLastName;

  /// No description provided for @profile_editPronouns.
  ///
  /// In en, this message translates to:
  /// **'Edit Pronouns'**
  String get profile_editPronouns;

  /// No description provided for @profile_editAge.
  ///
  /// In en, this message translates to:
  /// **'Edit Age'**
  String get profile_editAge;

  /// No description provided for @profile_editLocation.
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get profile_editLocation;

  /// No description provided for @profile_editBio.
  ///
  /// In en, this message translates to:
  /// **'Edit Bio'**
  String get profile_editBio;

  /// No description provided for @profile_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profile_save;

  /// No description provided for @profile_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get profile_success;

  /// No description provided for @profile_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get profile_error;

  /// No description provided for @profile_successMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profile_successMessage;

  /// No description provided for @profile_errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile. Please try again.'**
  String get profile_errorMessage;

  /// No description provided for @profile_ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get profile_ok;

  /// No description provided for @profile_hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get profile_hello;

  /// No description provided for @profile_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_editProfile;

  /// No description provided for @profile_ageError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age'**
  String get profile_ageError;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get nav_editProfile;

  /// No description provided for @nav_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get nav_logout;

  /// No description provided for @nav_headerTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get nav_headerTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
