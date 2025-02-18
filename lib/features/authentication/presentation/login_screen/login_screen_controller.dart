import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firebase_auth_repository.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<AsyncValue<void>> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading<void>();

    final AsyncValue<void> result = await AsyncValue.guard(() async {
      await authRepository.signInWithEmailPassword(email, password);
    });

    state = result;

    return result;
  }
}
