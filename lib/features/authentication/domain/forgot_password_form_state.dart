class ForgotPasswordFormState {
  const ForgotPasswordFormState({
    this.email = '',
    this.isLoading = false,
  });

  final String email;
  final bool isLoading;

  bool get isResetPasswordDisabled => email.isEmpty;

  ForgotPasswordFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
  }) {
    return ForgotPasswordFormState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
