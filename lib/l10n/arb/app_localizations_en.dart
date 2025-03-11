import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get global_title => 'RetroSpace';

  @override
  String get global_genericErrorMessage => 'Please try again Later';

  @override
  String get global_genericErrorTitle => 'Unexpected Error';

  @override
  String get global_emailSent => 'Email Sent';

  @override
  String get global_having_trouble => 'Having Trouble?';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_enterEmail => 'Please enter your email';

  @override
  String get auth_resend_email => 'Resend Email';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_enterPassword => 'Please enter your password';

  @override
  String get auth_confirmPassword => 'Confirm Password';

  @override
  String get auth_reenterPassword => 'Please reenter your password';

  @override
  String get auth_unableToResetPassword => 'Unable to Reset Password';

  @override
  String get auth_resetPassword => 'Reset Password';

  @override
  String get auth_forgotPassword => 'Forgot Your Password?';

  @override
  String get auth_forgotPasswordEmail =>
      'Check your email to reset your password';

  @override
  String get auth_login => 'Login';

  @override
  String get auth_createAnAccount => 'Create an Account';

  @override
  String get auth_createAccount => 'Create Account';

  @override
  String get auth_haveAccountLogin => 'Have an account? Login';

  @override
  String get auth_unableToLogin => 'Unable to log in';

  @override
  String get auth_unableToCreateAccount => 'Unable to Create Account';

  @override
  String get auth_please_verify_email =>
      'Please verify your email address. A confirmation link has been sent to your email. Once verified, sign in again to continue.';

  @override
  String get auth_verification_email_sent => 'Verification email has been sent';

  @override
  String get auth_emailErrorMessage => 'Please enter a valid email address';

  @override
  String get auth_passwordErrorMessage =>
      'Password must be at least 5 characters long';

  @override
  String get auth_passwordMatchErrorMessage => 'Passwords do not match';

  @override
  String get dialog_dismiss => 'Dismiss';

  @override
  String count_counter(int counter) {
    return 'Counter: $counter';
  }

  @override
  String get profile_username => 'Username';

  @override
  String get profile_firstName => 'First Name';

  @override
  String get profile_lastName => 'Last Name';

  @override
  String get profile_pronouns => 'Pronouns';

  @override
  String get profile_age => 'Age';

  @override
  String get profile_location => 'Location';

  @override
  String get profile_bio => 'Bio';

  @override
  String get profile_editUsername => 'Edit Username';

  @override
  String get profile_editFirstName => 'Edit First Name';

  @override
  String get profile_editLastName => 'Edit Last Name';

  @override
  String get profile_editPronouns => 'Edit Pronouns';

  @override
  String get profile_editAge => 'Edit Age';

  @override
  String get profile_editLocation => 'Edit Location';

  @override
  String get profile_editBio => 'Edit Bio';

  @override
  String get profile_save => 'Save';

  @override
  String get profile_success => 'Success';

  @override
  String get profile_error => 'Error';

  @override
  String get profile_successMessage => 'Profile updated successfully!';

  @override
  String get profile_errorMessage =>
      'Failed to update profile. Please try again.';

  @override
  String get profile_ok => 'Ok';

  @override
  String get profile_hello => 'Hello';

  @override
  String get profile_editProfile => 'Edit Profile';

  @override
  String get profile_ageError => 'Enter a valid age';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_editProfile => 'Edit Profile';

  @override
  String get nav_logout => 'Log out';

  @override
  String get nav_headerTitle => 'Menu';
}
