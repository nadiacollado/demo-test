import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_starter_kit/utils/auth_status.dart';

class FirebaseAuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;

    switch (e.code) {
      case 'invalid-email':
        status = AuthStatus.invalidEmail;
        break;
      case 'invalid-credential':
        status = AuthStatus.wrongPassword;
        break;
      case 'email-already-in-use':
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;

    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Invalid email address.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage = "The email address is already in use.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}
