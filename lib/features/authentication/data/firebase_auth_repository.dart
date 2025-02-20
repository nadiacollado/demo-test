import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    } on FirebaseAuthException catch (e) {
      _status = FirebaseAuthExceptionHandler.handleAuthException(e);
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
    } on FirebaseAuthException catch (e) {
      _status = FirebaseAuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
