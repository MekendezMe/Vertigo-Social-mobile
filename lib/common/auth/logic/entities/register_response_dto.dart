class RegisterResponseDto {
  final int userId;
  final String name;
  final String? username;

  RegisterResponseDto({
    required this.userId,
    required this.name,
    this.username,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      username: json['username'] as String?,
    );
  }
}
