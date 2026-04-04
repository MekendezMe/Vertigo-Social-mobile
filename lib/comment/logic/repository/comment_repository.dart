import 'package:social_network_flutter/comment/logic/entities/request/get_answers_request.dart';
import 'package:social_network_flutter/comment/logic/entities/response/get_answers_response.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/comment/logic/entities/request/get_comments_request.dart';
import 'package:social_network_flutter/comment/logic/entities/response/get_comments_response.dart';

class CommentRepository {
  final RequestSender requestSender;

  CommentRepository({required this.requestSender});

  Future<GetCommentsResponse> getCommentsByPost(
    GetCommentsRequest request,
  ) async {
    try {
      final response = await requestSender.send<GetCommentsResponse>(
        request: request,
        fromJson: (json) => GetCommentsResponse.fromJson(json),
        pathParams: request.paramsIntoPath(),
        queryParams: request.queryParamsToJson(),
      );

      if (response == null) {
        throw ApiException(
          message: "Пустой ответ сервера в методе ${request.method}",
          code: -1,
        );
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAnswersResponse> getAnswersByComment(
    GetAnswersRequest request,
  ) async {
    try {
      final response = await requestSender.send<GetAnswersResponse>(
        request: request,
        fromJson: (json) => GetAnswersResponse.fromJson(json),
        pathParams: request.paramsIntoPath(),
        queryParams: request.queryParamsToJson(),
      );

      if (response == null) {
        throw ApiException(
          message: "Пустой ответ сервера в методе ${request.method}",
          code: -1,
        );
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
