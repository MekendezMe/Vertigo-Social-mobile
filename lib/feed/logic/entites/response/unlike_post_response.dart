class UnlikePostResponse {
  final bool success;

  UnlikePostResponse({required this.success});

  factory UnlikePostResponse.fromJson(Map<String, dynamic> json) {
    return UnlikePostResponse(success: json['success'] as bool);
  }
}
