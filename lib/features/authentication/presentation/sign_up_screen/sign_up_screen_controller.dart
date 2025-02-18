import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firebase_auth_repository.dart';

part 'sign_up_screen_controller.g.dart';

@riverpod
class SignUpScreenController extends _$SignUpScreenController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(
      () => authRepository.signUpWithEmailPassword(email, password),
    );
  }
}
