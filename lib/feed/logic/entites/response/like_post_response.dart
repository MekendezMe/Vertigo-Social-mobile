class LikePostResponse {
  final bool success;

  LikePostResponse({required this.success});

  factory LikePostResponse.fromJson(Map<String, dynamic> json) {
    return LikePostResponse(success: json['success'] as bool);
  }
}
