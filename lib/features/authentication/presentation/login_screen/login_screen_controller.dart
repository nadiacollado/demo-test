import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/auth_state_notifier.dart';
import '../../domain/login_form_state.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  late final AuthStateNotifier _authStateNotifier;

  @override
  LoginFormState build() {
    _authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    return const LoginFormState();
  }

  void updateEmail(String email) {
    state = state.copyWith(
      email: email,
    );
  }

  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
    );
  }

  Future<void> signInWithEmailPassword() async {
    state = state.copyWith(isLoading: true);

    await _authStateNotifier.signInWithEmailPassword(
      state.email,
      state.password,
    );

    state = state.copyWith(isLoading: false);
  }
}
