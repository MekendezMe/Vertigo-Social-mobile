import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class CreatePostRequest extends IRequest {
  @override
  String get method => "feed/createPost";
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  final int userId;
  final String text;

  CreatePostRequest({required this.userId, required this.text});

  Map<String, dynamic> toJson() {
    return {"user_id": userId, "text": text};
  }
}
