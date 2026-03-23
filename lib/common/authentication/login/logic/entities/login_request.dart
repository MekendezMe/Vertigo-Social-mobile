import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class LoginRequest extends IRequest {
  @override
  String get method => "auth/signin";
  @override
  bool get isAuthRequired => false;
  @override
  HttpMethod get httpMethod => HttpMethod.post;

  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
