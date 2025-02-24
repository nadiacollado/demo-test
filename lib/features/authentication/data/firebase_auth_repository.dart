import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/logger.dart';
import '../domain/auth_status.dart';
import '../domain/firebase_auth_exception_handler.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;
  AuthStatus _status = AuthStatus.unknown;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<AuthStatus> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _status = AuthStatus.successful;
      logger.info(
        message: 'User sign-in successful: ${_auth.currentUser?.uid}',
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      _status = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.error(message: e.toString(), stack: stackTrace);
    }
    return _status;
  }

  Future<AuthStatus> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _status = AuthStatus.successful;
      logger.info(
        message: 'User sign-up successful: ${_auth.currentUser?.uid}',
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      _status = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.error(message: e.toString(), stack: stackTrace);
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
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
