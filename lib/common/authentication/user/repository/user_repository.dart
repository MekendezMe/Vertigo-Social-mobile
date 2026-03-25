import 'package:social_network_flutter/common/authentication/user/entities/get_current_user_request.dart';
import 'package:social_network_flutter/common/authentication/user/entities/get_current_user_response.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UserRepository {
  final RequestSender requestSender;
  final Talker talker;

  UserRepository({required this.requestSender, required this.talker});

  Future<GetCurrentUserResponse> getCurrentUser() async {
    final request = GetCurrentUserRequest();
    try {
      final response = await requestSender.send(
        request: request,
        fromJson: (json) => GetCurrentUserResponse.fromJson(json),
      );
      if (response == null) {
        throw ApiException(message: "Пустой ответ в методе ${request.method}");
      }
      return response;
    } catch (e, st) {
      talker.handle(e, st);
      rethrow;
    }
  }
}
