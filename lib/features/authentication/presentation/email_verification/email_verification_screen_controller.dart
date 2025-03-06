import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firebase_auth_repository.dart';
import '../../domain/auth_status.dart';

part 'email_verification_screen_controller.g.dart';

@riverpod
class EmailVerificationScreenController
    extends _$EmailVerificationScreenController {
  @override
  FutureOr<void> build() {}

  Future<AsyncValue<AuthStatus>> sendVerificationEmailAddress() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);

    final AsyncValue<AuthStatus> result =
        await AsyncValue.guard<AuthStatus>(() async {
      try {
        final AuthStatus result = await authRepository.sendVerificationEmail();
        return result;
      } catch (e) {
        return AuthStatus.unknown;
      }
    });
    return result;
  }
}
