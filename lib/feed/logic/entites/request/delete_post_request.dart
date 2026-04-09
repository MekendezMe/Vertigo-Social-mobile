import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class DeletePostRequest extends IRequest {
  final int postId;

  DeletePostRequest({required this.postId});
  @override
  String get method => "posts/$postId";
  @override
  // TODO: implement httpMethod
  HttpMethod get httpMethod => HttpMethod.delete;
}
