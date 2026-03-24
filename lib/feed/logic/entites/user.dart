class User {
  final int userId;
  final String name;
  final String? username;
  final String? avatar;

  User({
    required this.userId,
    required this.name,
    required this.username,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      userId: json['user_id'] as int,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
