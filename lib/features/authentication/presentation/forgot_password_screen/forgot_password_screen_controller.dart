import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firebase_auth_repository.dart';
import '../../domain/auth_status.dart';
import '../../domain/forgot_password_form_state.dart';

part 'forgot_password_screen_controller.g.dart';

@riverpod
class ForgotPasswordScreenController extends _$ForgotPasswordScreenController {
  @override
  ForgotPasswordFormState build() => const ForgotPasswordFormState();

  void updateEmail(String email) {
    state = state.copyWith(
      email: email,
    );
  }

  Future<AsyncValue<AuthStatus>> resetPasswordWithEmail() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true);

    final AsyncValue<AuthStatus> result =
        await AsyncValue.guard<AuthStatus>(() async {
      try {
        final AuthStatus result = await authRepository.resetPassword(
          state.email,
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
