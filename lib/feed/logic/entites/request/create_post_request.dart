import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/feed/logic/helpers/extension_file_checker.dart';

class CreatePostRequest extends IRequest {
  @override
  String get method => "posts";
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  final String text;
  final List<File> media;

  CreatePostRequest({required this.text, required this.media});

  Map<String, dynamic> toJson() {
    return {"content": text};
  }

  Future<FormData> getBodyWithMedia() async {
    final formData = FormData();
    formData.fields.add(MapEntry('content', text));
    for (int i = 0; i < media.length; i++) {
      final file = media[i];
      final isVideo = isVideoByUrl(file.path);
      final fileName = isVideo ? 'video_$i.mp4' : 'image_$i.jpg';
      final mimeType = isVideo ? 'video/mp4' : 'image/jpeg';
      formData.files.add(
        MapEntry(
          'media',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        ),
      );
    }
    return formData;
  }
}
