import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';

class ErrorHandler {
  void handle(dynamic error, {BuildContext? context}) {
    if (error is NoInternetException) {
      _showNoInternetToast();
    } else if (error is ApiException) {
      _showApiErrorToast(error.message);
    } else if (error is AuthException) {
      _showAuthErrorToast(error.message);
    } else {
      _showGenericErrorToast();
    }
  }

  void _showNoInternetToast() {
    CustomToast.show(
      CustomToastWidget(text: "Отсутствует подключение к интернету"),
      dismissAfter: Duration(seconds: 1),
    );
  }

  void _showApiErrorToast(String message) {
    CustomToast.show(
      CustomToastWidget(text: message),
      dismissAfter: Duration(seconds: 1),
    );
  }

  void _showAuthErrorToast(String message) {
    CustomToast.show(
      CustomToastWidget(text: message),
      dismissAfter: Duration(seconds: 1),
    );
  }

  void _showGenericErrorToast() {
    CustomToast.show(
      CustomToastWidget(text: "Произошла ошибка. Попробуйте позже."),
      dismissAfter: Duration(seconds: 1),
    );
  }
}
