import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../utils/auth_status.dart';
import '../../data/firebase_auth_repository.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  FutureOr<void> build() {
    // Initialize state
  }

  String _email = '';
  String _password = '';

  bool get isLoginDisabled =>
      _email.isEmpty || _password.isEmpty || _password.length < 6;

  void updateEmail(String email) {
    _email = email;
  }

  void updatePassword(String password) {
    _password = password;
  }

  Future<AsyncValue<AuthStatus>> signInWithEmailPassword() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();

    final AsyncValue<AuthStatus> result =
        await AsyncValue.guard<AuthStatus>(() async {
      try {
        final AuthStatus result =
            await authRepository.signInWithEmailPassword(_email, _password);
        return result;
      } catch (e) {
        return AuthStatus.unknown;
      }
    });

    state = result;
    return result;
  }
}
