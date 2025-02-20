import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firebase_auth_repository.dart';
import '../../domain/auth_status.dart';
import '../../domain/sign_up_form_state.dart';

part 'sign_up_screen_controller.g.dart';

@riverpod
class SignUpScreenController extends _$SignUpScreenController {
  @override
  SignUpFormState build() => const SignUpFormState();

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

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  Future<AsyncValue<AuthStatus>> signUpWithEmailPassword() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true);

    final AsyncValue<AuthStatus> result =
        await AsyncValue.guard<AuthStatus>(() async {
      try {
        final AuthStatus result = await authRepository.signUpWithEmailPassword(
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
