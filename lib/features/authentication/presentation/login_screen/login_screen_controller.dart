import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firebase_auth_repository.dart';
import '../../domain/auth_status.dart';
import '../../domain/login_form_state.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  LoginFormState build() => const LoginFormState();

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

  Future<AsyncValue<AuthStatus>> signInWithEmailPassword() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true);

    final AsyncValue<AuthStatus> result =
        await AsyncValue.guard<AuthStatus>(() async {
      try {
        final AuthStatus result = await authRepository.signInWithEmailPassword(
          state.email,
          state.password,
        );
        return result;
      } catch (e) {
        return AuthStatus.unknown;
      } finally {
        state = state.copyWith(isLoading: false);
      }
    });
    return result;
  }
}
