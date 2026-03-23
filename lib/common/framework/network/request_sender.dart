import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/service/token_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum HttpMethod { post, get, delete }

extension HttpMethodExtension on HttpMethod {
  String get text {
    switch (this) {
      case HttpMethod.post:
        return "POST";
      case HttpMethod.get:
        return "GET";
      case HttpMethod.delete:
        return "DELETE";
    }
  }
}

abstract class IRequest {
  HttpMethod get httpMethod => HttpMethod.post;

  String? get urlOverride => null;

  String? get apiVersion => null;
  String get method;

  bool get isAuthRequired => true;

  Map<String, String> get headers => {
    "Content-Type": "application/json",
    "charset": "utf-8",
  };
}

class RequestSender {
  RequestSender({
    required this.talker,
    required this.tokenService,
    required this.secureStorage,
    required this.dio,
  });
  final TokenService tokenService;
  final ISecureStorage secureStorage;
  final Talker talker;
  final Dio dio;
  Future<T?> send<T>({
    required IRequest request,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    try {
      await _checkConnectivity();
      final headers = Map<String, String>.from(request.headers);
      // if (request.isAuthRequired) {
      //   final token = tokenService.accessToken;
      //   if (token != null && token.isNotEmpty) {
      //     headers['Authorization'] = 'Bearer $token';
      //   } else {
      //     throw AuthException(
      //       message: 'Требуется авторизация. Нет токена',
      //       code: 401,
      //     );
      //   }
      // }

      final response = await _sendRequest(
        request: request,
        body: body,
        queryParams: queryParams,
        dio: dio,
        headers: headers,
      );

      final statusCode = response?.statusCode ?? -1;

      if (statusCode == 401) {
        throw AuthException();
      }
      if (statusCode >= 400 || statusCode < 200) {
        throw ApiException(
          message: response?.statusMessage ?? "Ошибка сервера",
          code: statusCode,
        );
      }
      if (statusCode == 204) {
        return null;
      }

      if (response == null || response.data == null) {
        throw ApiException(
          message: 'Пустой ответ от сервера',
          code: statusCode,
        );
      }

      final json = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : null;

      if (json?.isEmpty ?? true) {
        throw ApiException(
          message: "Сервер вернул пустой объект",
          code: statusCode,
        );
      }

      return fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? -1;
      if (statusCode == 401) {
        throw AuthException();
      }
      throw ApiException(
        message: e.message ?? "Ошибка сервера",
        code: statusCode,
      );
    } on NoInternetException catch (e) {
      talker.handle(e);
      rethrow;
    } catch (e, st) {
      talker.handle(e, st);
      rethrow;
    }
  }

  Future<Response?> _sendRequest<T, B>({
    required IRequest request,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    required Dio dio,
    required Map<String, String> headers,
  }) async {
    final response = await dio.request(
      request.method,
      data: body,
      queryParameters: queryParams,
      options: Options(method: request.httpMethod.text, headers: headers),
    );
    return response;
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty ||
        connectivityResult[0] == ConnectivityResult.none) {
      throw NoInternetException();
    }
  }
}
