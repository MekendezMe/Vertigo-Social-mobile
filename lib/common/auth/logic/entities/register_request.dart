import 'package:social_network_flutter/common/framework/network/request_sender.dart';

class RegisterRequest extends IRequest {
  final String name;
  final String? username;
  final String email;
  final String password;

  RegisterRequest({
    required this.name,
    this.username,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      name: json['name'] as String,
      username: json['username'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  @override
  String get method => "auth/signup";
  @override
  HttpMethod get httpMethod => HttpMethod.post;
}
