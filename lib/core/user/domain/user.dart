class User {
  const User({
    required this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.age,
    this.location,
    this.pronouns,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      username: json['username'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      age: json['age'] as String?,
      location: json['location'] as String?,
      pronouns: json['pronouns'] as String?,
      bio: json['bio'] as String?,
    );
  }

  final String email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? age;
  final String? location;
  final String? pronouns;
  final String? bio;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'firsName': firstName,
      'lastName': lastName,
      'age': age,
      'location': location,
      'pronouns': pronouns,
      'bio': bio,
    };
  }
}
