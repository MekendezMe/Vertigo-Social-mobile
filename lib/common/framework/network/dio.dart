import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/environment/environment.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

Dio getDio({required Talker talker, required Environment environment}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: environment.baseUrl + environment.version,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    ),
  );

  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printResponseMessage: true,
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseData: true,
        printRequestExtra: true,
      ),
    ),
  );

  return dio;
}
