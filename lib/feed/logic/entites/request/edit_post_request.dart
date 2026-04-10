import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class EditPostRequest extends IRequest {
  final int postId;
  final String text;
  final List<String> deletedImages;
  final List<File> images;

  EditPostRequest({
    required this.postId,
    required this.text,
    required this.deletedImages,
    required this.images,
  });

  Future<FormData> getBodyWithPhotos() async {
    final formData = FormData();
    formData.fields.add(MapEntry('content', text));
    formData.fields.add(MapEntry('deleted_images', jsonEncode(deletedImages)));
    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(file.path, filename: 'image_$i.jpg'),
        ),
      );
    }
    return formData;
  }

  @override
  String get method => "posts/$postId";
  @override
  HttpMethod get httpMethod => HttpMethod.patch;
}
