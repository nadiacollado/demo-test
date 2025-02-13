import 'package:flutter_starter_kit/features/authentication/data/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_screen_controller.g.dart';

@riverpod
class SignUpScreenController extends _$SignUpScreenController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => authRepository.signUpWithEmailPassword(email, password));
  }
}
