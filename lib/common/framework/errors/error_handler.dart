import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/common/launcher/launcher_dependencies.dart';

class ErrorHandler {
  final ILogoutHandler logoutHandler;

  ErrorHandler({required this.logoutHandler});
  void handle(dynamic error, {BuildContext? context}) {
    if (error is NoInternetException) {
      _onNoInternet();
    } else if (error is ApiException) {
      _onApiError(error.message);
    } else if (error is AuthException) {
      _onAuthError(error.message);
    } else {
      _onError(error);
    }
  }

  void _onNoInternet() {
    CustomToast.show(
      CustomToastWidget(text: "Отсутствует подключение к интернету"),
      dismissAfter: Duration(seconds: 1),
    );
  }

  void _onApiError(String message) {
    CustomToast.show(
      CustomToastWidget(text: message),
      dismissAfter: Duration(seconds: 1),
    );
  }

  void _onAuthError(String message) {
    CustomToast.show(
      CustomToastWidget(text: "Не удалось авторизоваться"),
      dismissAfter: Duration(seconds: 1),
    );
    logoutHandler.onLogout();
  }

  void _onError(dynamic error) {
    String message;

    if (error is String) {
      message = error;
    } else if (error is Exception) {
      message = error.toString();
    } else {
      message = "Произошла ошибка. Попробуйте позже.";
    }
    CustomToast.show(
      CustomToastWidget(text: message),
      dismissAfter: Duration(seconds: 2),
    );
  }
}
