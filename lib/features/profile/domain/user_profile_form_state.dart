import '../../../core/user/domain/user.dart';

class UserProfileFormState {
  const UserProfileFormState({
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.age,
    this.location,
    this.pronouns,
    this.bio,
    this.originalUser,
  });
  final String? email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? age;
  final String? location;
  final String? pronouns;
  final String? bio;
  final User? originalUser;

  UserProfileFormState copyWith({
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? age,
    String? location,
    String? pronouns,
    String? bio,
    User? originalUser,
  }) {
    return UserProfileFormState(
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      location: location ?? this.location,
      pronouns: pronouns ?? this.pronouns,
      bio: bio ?? this.bio,
      originalUser: originalUser ?? this.originalUser,
    );
  }

  Map<String, dynamic> getChangedFields() {
    final Map<String, dynamic> updates = <String, dynamic>{};

    if (email != originalUser?.email) updates['email'] = email;
    if (username != originalUser?.username) updates['username'] = username;
    if (firstName != originalUser?.firstName) updates['firstName'] = firstName;
    if (lastName != originalUser?.lastName) updates['lastName'] = lastName;
    if (age != originalUser?.age) updates['age'] = age;
    if (location != originalUser?.location) updates['location'] = location;
    if (pronouns != originalUser?.pronouns) updates['pronouns'] = pronouns;
    if (bio != originalUser?.bio) updates['bio'] = bio;

    return updates;
  }
}
