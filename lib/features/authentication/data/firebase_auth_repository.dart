import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/logger.dart';
import '../application/email_verification_service.dart';
import '../domain/auth_status.dart';
import '../domain/firebase_auth_exception_handler.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth, this._emailVerificationService);
  final FirebaseAuth _auth;
  final EmailVerificationService _emailVerificationService;

  AuthStatus _status = AuthStatus.unknown;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<AuthStatus> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final bool isEmailVerified =
          await _emailVerificationService.isEmailVerified(result.user);

      _status = isEmailVerified
          ? AuthStatus.authenticated
          : AuthStatus.emailNotVerified;
      logger.info(
        message: 'User sign-in successful: ${_auth.currentUser?.uid}',
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      _status = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.error(message: e.toString(), stack: stackTrace);
    }
    return _status;
  }

  Future<AuthStatus> createUser(String email, String password) async {
    try {
      final HttpsCallableResult<Map<String, dynamic>> response =
          await FirebaseFunctions.instance
              .httpsCallable('createUser')
              .call(<String, String>{'email': email, 'password': password});

      logger.info(message: 'User created: ${response.data}');
      _status = AuthStatus.emailNotVerified;
      if (response.data.isNotEmpty) {
        final UserCredential credential = await _auth
            .signInWithEmailAndPassword(email: email, password: password);

        if (credential.user != null) {
          await sendVerificationEmail();
        }
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      _status = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.error(message: e.toString(), stack: stackTrace);
    }
    return _status;
  }

  Future<AuthStatus> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = FirebaseAuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      _status = AuthStatus.unknown;
    }

    return _status;
  }

  Future<AuthStatus> sendVerificationEmail() async {
    final User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        _status = AuthStatus.successful;
      } on FirebaseAuthException catch (e) {
        _status = FirebaseAuthExceptionHandler.handleAuthException(e);
      } catch (e) {
        _status = AuthStatus.unknown;
      }
    }
    return _status;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      logger.info(
        message: 'User signed out successfully',
      );
    } catch (e, stackTrace) {
      logger.error(
        message: e.toString(),
        stack: stackTrace,
      );
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final FirebaseAuth firebaseAuth = ref.watch(firebaseAuthProvider);
  final EmailVerificationService emailVerificationService =
      ref.watch(emailVerificationServiceProvider);

  return AuthRepository(firebaseAuth, emailVerificationService);
}

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
