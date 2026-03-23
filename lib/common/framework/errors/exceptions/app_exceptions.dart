abstract class AppException implements Exception {
  final String message;
  final int? code;

  AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ApiException extends AppException {
  ApiException({required super.message, super.code});
}

class AuthException extends AppException {
  AuthException({super.message = "Не удалось авторизоваться", super.code});
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({required super.message, this.errors});
}

class NoInternetException extends AppException {
  NoInternetException() : super(message: 'Нет подключения к интернету');
}

class TimeoutException extends AppException {
  TimeoutException() : super(message: 'Превышено время ожидания');
}
