import '../../../core/user/domain/user.dart';

class UserProfileFormState {
  const UserProfileFormState({
    this.email,
    this.username,
    this.originalUser,
  });
  final String? email;
  final String? username;
  final User? originalUser;

  UserProfileFormState copyWith({
    String? email,
    String? username,
    User? originalUser,
  }) {
    return UserProfileFormState(
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
