class User {
  final int id;
  final String username;
  final String? name;
  final String? lastName;

  final String? avatar;

  User({
    required this.id,
    required this.username,
    this.name,
    this.lastName,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as int,
      username: json['username'] as String,
      name: json['name'] as String?,
      lastName: json['last_name'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
