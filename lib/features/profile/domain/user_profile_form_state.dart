import '../../../core/user/domain/user.dart';

class UserProfileFormState {
  const UserProfileFormState({
    this.isLoading = false,
    this.email,
    this.username,
    this.originalUser,
  });
  final bool isLoading;
  final String? email;
  final String? username;
  final User? originalUser;

  UserProfileFormState copyWith({
    bool? isLoading,
    String? email,
    String? username,
    User? originalUser,
  }) {
    return UserProfileFormState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      username: username ?? this.username,
      originalUser: originalUser ?? this.originalUser,
    );
  }

  Map<String, dynamic> getChangedFields() {
    final Map<String, dynamic> updates = <String, dynamic>{};

    if (email != originalUser?.email) updates['email'] = email;
    if (username != originalUser?.username) updates['username'] = username;

    return updates;
  }
}
