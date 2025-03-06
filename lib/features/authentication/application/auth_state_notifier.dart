import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/logger.dart';
import '../data/firebase_auth_repository.dart';
import '../domain/auth_state.dart';
import '../domain/auth_status.dart';

part 'auth_state_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  late final AuthRepository _authRepository;

  @override
  FutureOr<AuthState> build() async {
    _authRepository = ref.watch(authRepositoryProvider);

    _listenToAuthChanges();

    return const AuthState(status: AuthStatus.isLoading);
  }

  void _listenToAuthChanges() {
    _authRepository.authStateChanges().listen((User? user) async {
      if (user == null) {
        state = AsyncValue<AuthState>.data(
          AuthState(status: AuthStatus.unauthenticated, user: user),
        );
      } else {
        await _checkEmailVerification(user);
      }
    });
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    state = const AsyncLoading<AuthState>();

    try {
      final AuthStatus status =
          await _authRepository.signInWithEmailPassword(email, password);
      state = AsyncValue<AuthState>.data(
        AuthState(status: status),
      );
    } catch (e, st) {
      state = AsyncValue<AuthState>.error(e, st);
    }
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    state = const AsyncLoading<AuthState>();
    try {
      final AuthStatus status =
          await _authRepository.createUser(email, password);

      state = AsyncValue<AuthState>.data(
        AuthState(status: status),
      );
    } catch (e, st) {
      state = AsyncValue<AuthState>.error(e, st);
    }
  }

  Future<void> sendVerificationEmail() async {
    final User? user = _authRepository.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } on FirebaseAuthException catch (e, stackTrace) {
        logger.error(message: e.toString(), stack: stackTrace);
      } catch (e, stackTrace) {
        logger.error(
          message: 'Exception $e',
          stack: stackTrace,
        );
      }
    }
  }

  Future<void> _checkEmailVerification(User user) async {
    state = const AsyncLoading<AuthState>();
    final AuthStatus status = await _authRepository.isEmailVerified(user);

    if (state.value?.status != status) {
      state = AsyncValue<AuthState>.data(
        AuthState(status: status, user: user),
      );
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading<AuthState>();

    await _authRepository.signOut();

    state = const AsyncValue<AuthState>.data(
      AuthState(status: AuthStatus.unauthenticated),
    );
  }
}
