import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/auth_status.dart';

class LoginFormState {
  LoginFormState({
    this.email = '',
    this.password = '',
    this.status = const AsyncData<AuthStatus>(AuthStatus.unknown),
  });
  final String email;
  final String password;
  final AsyncValue<AuthStatus> status;

  // `copyWith` method to update the state
  LoginFormState copyWith({
    String? email,
    String? password,
    AsyncValue<AuthStatus>? status,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
