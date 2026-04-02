import 'package:flutter/widgets.dart';
import 'package:social_network_flutter/common/authentication/login/logic/bloc/login_bloc.dart';
import 'package:social_network_flutter/common/authentication/login/ui/screens/login_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class LoginCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Widget Function() showMain;
  final Function({required BuildContext context}) onShowForgotPassword;
  LoginCoordinator({
    required this.diContainer,
    required this.showMain,
    required this.onShowForgotPassword,
  });
  void showLoginScreen({required BuildContext context}) {
    push(
      context: context,
      page: LoginScreen(
        loginBloc: diContainer.resolve<LoginBloc>(),
        onShowMain: onShowMain,
        onShowForgotPassword: onShowForgotPassword,
      ),
    );
  }

  void onShowMain({required BuildContext context}) {
    pushReplacement(context: context, page: showMain());
  }
}
