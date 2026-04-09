class DeletePostResponse {
  final bool success;

  DeletePostResponse({required this.success});

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) {
    return DeletePostResponse(success: json['success']);
  }
}
