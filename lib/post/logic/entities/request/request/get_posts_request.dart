import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/post/logic/entities/post_types.dart';

class GetPostsRequest extends IRequest {
  final int pageNumber;
  final PostType? type;

  Map<String, dynamic> queryParamsToJson() {
    final postType = type != null
        ? getPostType(type!)
        : getPostType(PostType.all);
    return {'page_number': pageNumber, "type": postType};
  }

  GetPostsRequest({required this.pageNumber, this.type});
  @override
  String get method => "posts";
  @override
  HttpMethod get httpMethod => HttpMethod.get;
}
