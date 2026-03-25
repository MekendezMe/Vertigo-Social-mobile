import 'package:social_network_flutter/feed/logic/entites/user.dart';

class GetCurrentUserResponse {
  final User user;

  GetCurrentUserResponse({required this.user});

  factory GetCurrentUserResponse.fromJson(Map<String, dynamic> json) {
    return GetCurrentUserResponse(user: User.fromJson(json['user']));
  }
}
