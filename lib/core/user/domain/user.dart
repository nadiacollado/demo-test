class User {
  const User({
    required this.email,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      username: json['username'] as String?,
    );
  }

  final String email;
  final String? username;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'username': username,
    };
  }
}
