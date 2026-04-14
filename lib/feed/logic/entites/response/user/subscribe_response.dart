class SubscribeResponse {
  final bool success;

  SubscribeResponse({required this.success});

  factory SubscribeResponse.fromJson(Map<String, dynamic> json) {
    return SubscribeResponse(success: json['success'] as bool);
  }
}
