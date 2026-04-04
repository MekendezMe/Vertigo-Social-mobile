import 'dart:io';

import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class CreatePostRequest extends IRequest {
  @override
  String get method => "posts";
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  final String text;
  final List<File> images;

  CreatePostRequest({required this.text, required this.images});

  Map<String, dynamic> toJson() {
    return {"content": text, "images": images};
  }
}
