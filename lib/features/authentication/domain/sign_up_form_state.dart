class SignUpFormState {
  const SignUpFormState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
  });
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;

  bool get isSignUpDisabled =>
      email.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty ||
      password != confirmPassword;

  SignUpFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
