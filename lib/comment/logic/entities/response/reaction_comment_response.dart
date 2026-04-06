class ReactionCommentResponse {
  final bool success;

  ReactionCommentResponse({required this.success});

  factory ReactionCommentResponse.fromJson(Map<String, dynamic> json) {
    return ReactionCommentResponse(success: json['success'] as bool);
  }
}
