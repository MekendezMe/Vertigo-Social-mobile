class ReactionPostResponse {
  final bool success;

  ReactionPostResponse({required this.success});

  factory ReactionPostResponse.fromJson(Map<String, dynamic> json) {
    return ReactionPostResponse(success: json['success'] as bool);
  }
}
