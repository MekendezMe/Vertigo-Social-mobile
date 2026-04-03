import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class GetPostRequest extends IRequest {
  final int postId;

  GetPostRequest({required this.postId});

  Map<String, dynamic> paramsIntoPath() {
    return {"postId": postId};
  }

  @override
  String get method => "posts/{postId}";
  @override
  HttpMethod get httpMethod => HttpMethod.get;
}
