class SaveTokenResponse {
  final bool success;

  SaveTokenResponse({required this.success});

  factory SaveTokenResponse.fromJson(Map<String, dynamic> json) {
    return SaveTokenResponse(success: json['success'] as bool);
  }
}
