import '../../../core/user/domain/user.dart';

class UserProfileFormState {
  const UserProfileFormState({
    this.originalUser,
    this.email,
    this.username,
  });
  final User? originalUser;
  final String? email;
  final String? username;

  UserProfileFormState copyWith({
    User? originalUser,
    String? email,
    String? username,
  }) {
    return UserProfileFormState(
      originalUser: originalUser ?? this.originalUser,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> getChangedFields() {
    final Map<String, dynamic> updates = <String, dynamic>{};

    if (email != originalUser?.email) updates['email'] = email;
    if (username != originalUser?.username) updates['username'] = username;

    return updates;
  }
}
