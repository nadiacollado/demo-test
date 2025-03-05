// ignore_for_file: no_default_cases
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_status.dart';

class FirebaseAuthExceptionHandler {
  static AuthStatus handleAuthException(FirebaseAuthException e) {
    AuthStatus status;

    switch (e.code) {
      case 'invalid-email':
        status = AuthStatus.invalidEmail;
      case 'invalid-credential':
        status = AuthStatus.wrongPassword;
      case 'email-already-in-use':
        status = AuthStatus.emailAlreadyExists;
      case 'user-not-found':
        status = AuthStatus.userNotFound;
      case 'too-many-requests':
        status = AuthStatus.tooManyRequests;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(AuthStatus error) {
    String errorMessage;

    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = 'Invalid email address.';
      case AuthStatus.wrongPassword:
        errorMessage = 'Your email or password is wrong.';
      case AuthStatus.emailAlreadyExists:
        errorMessage = 'The email address is already in use.';
      case AuthStatus.tooManyRequests:
        errorMessage = "You've made too many requests in a short period";
      default:
        errorMessage = 'An error occurred. Please try again later.';
    }
    return errorMessage;
  }
}
