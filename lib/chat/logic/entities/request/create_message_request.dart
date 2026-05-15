import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/feed/logic/helpers/extension_file_checker.dart';

class CreateMessageRequest extends IRequest {
  final String chatId;
  final String senderId;
  final String? type;
  final String? content;
  final List<File>? media;
  final String? replyId;
  final String? postId;
  final List<String>? forwardedMessageIds;

  CreateMessageRequest({
    required this.chatId,
    required this.senderId,
    this.type,
    this.content,
    this.media,
    this.replyId,
    this.postId,
    this.forwardedMessageIds,
  });
  @override
  String get method => "messages";
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  Future<FormData> getBody() async {
    final formData = FormData();
    if (content != null) {
      formData.fields.add(MapEntry('content', content!));
    }

    formData.fields.add(MapEntry('chat_id', chatId));
    formData.fields.add(MapEntry('sender_id', senderId));
    if (type != null) {
      formData.fields.add(MapEntry('type', type!));
    }

    if (postId != null) {
      formData.fields.add(MapEntry('post_id', postId!));
    }
    if (replyId != null) {
      formData.fields.add(MapEntry('reply_id', replyId!));
    }

    if (media != null) {
      for (int i = 0; i < media!.length; i++) {
        final file = media![i];
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
    }

    if (forwardedMessageIds != null) {
      for (int i = 0; i < forwardedMessageIds!.length; i++) {
        final id = forwardedMessageIds![i];
        formData.fields.add(MapEntry('forwarded_messages_id[]', id));
      }
    }

    return formData;
  }
}
