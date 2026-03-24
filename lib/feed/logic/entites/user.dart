class User {
  final int id;
  final String name;
  final String? username;
  final String? avatar;

  User({required this.id, required this.name, this.username, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as int,
      name: json['name'] as String,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
