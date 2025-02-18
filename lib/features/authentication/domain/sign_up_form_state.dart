class SignUpFormState {
  SignUpFormState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });
  final String email;
  final String password;
  final String confirmPassword;

  // Copy method to update state
  SignUpFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
