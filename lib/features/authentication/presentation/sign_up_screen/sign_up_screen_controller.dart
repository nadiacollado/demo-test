import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../utils/auth_status.dart';

import '../../data/firebase_auth_repository.dart';

part 'sign_up_screen_controller.g.dart';

@riverpod
class SignUpScreenController extends _$SignUpScreenController {
  @override
  FutureOr<void> build() {
    // no op
  }

  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool get isSignUpDisabled =>
      _email.isEmpty ||
      _password.isEmpty ||
      _confirmPassword.isEmpty ||
      _password != _confirmPassword ||
      _password.length < 6 ||
      _confirmPassword.length < 6;

  void updateEmail(String email) {
    _email = email;
  }

  void updatePassword(String password) {
    _password = password;
  }

  void updateConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
  }

  Future<AsyncValue<AuthStatus>> signUpWithEmailPassword() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();

    final AsyncValue<AuthStatus> result =
        await AsyncValue.guard<AuthStatus>(() async {
      try {
        final AuthStatus result =
            await authRepository.signUpWithEmailPassword(_email, _password);
        return result;
      } catch (e) {
        return AuthStatus.unknown;
      }
    });

    state = result;

    return result;
  }
}
