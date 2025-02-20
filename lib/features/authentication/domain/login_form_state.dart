class LoginFormState {
  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
  });
  final String email;
  final String password;
  final bool isLoading;

  bool get isLoginDisabled =>
      email.isEmpty || password.isEmpty || password.length < 6;

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
