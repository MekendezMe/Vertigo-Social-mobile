import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/post/logic/entities/request/create_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/delete_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/edit_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/get_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/like_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/request/get_posts_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/unlike_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/response/create_post_response.dart';
import 'package:social_network_flutter/post/logic/entities/response/delete_post_response.dart';
import 'package:social_network_flutter/post/logic/entities/response/get_post_response.dart';
import 'package:social_network_flutter/post/logic/entities/response/reaction_post_response.dart';
import 'package:social_network_flutter/post/logic/entities/response/response/edit_post_response.dart';
import 'package:social_network_flutter/post/logic/entities/response/response/get_posts_response.dart';

class PostRepository {
  final RequestSender requestSender;

  PostRepository({required this.requestSender});

  Future<GetPostResponse> getPost(GetPostRequest request) async {
    try {
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => GetPostResponse.fromJson(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPostsResponse> getPosts(GetPostsRequest request) async {
    try {
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => GetPostsResponse.fromJson(json),
        queryParams: request.queryParamsToJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePostResponse> createPost(CreatePostRequest request) async {
    try {
      final formData = await request.getBodyWithMedia();
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => CreatePostResponse.fromJson(json),
        formData: formData,
        body: request.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<EditPostResponse> editPost(EditPostRequest request) async {
    try {
      final formData = await request.getBodyWithMedia();
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => EditPostResponse.fromJson(json),
        formData: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DeletePostResponse> deletePost(DeletePostRequest request) async {
    try {
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => DeletePostResponse.fromJson(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ReactionPostResponse> likePost(LikePostRequest request) async {
    final response = await requestSender.send(
      request: request,
      fromJson: (json) => ReactionPostResponse.fromJson(json),
    );
    return response;
  }

  Future<ReactionPostResponse> unlikePost(UnlikePostRequest request) async {
    final response = await requestSender.send(
      request: request,
      fromJson: (json) => ReactionPostResponse.fromJson(json),
    );
    return response;
  }
}
