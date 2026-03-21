import 'package:flutter/widgets.dart';
import 'package:social_network_flutter/common/authentication/auth/logic/bloc/auth_bloc.dart';
import 'package:social_network_flutter/common/authentication/auth/ui/screens/auth_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class AuthCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Function({required BuildContext context}) onShowLogin;
  final Function({required BuildContext context}) onShowRegister;
  AuthCoordinator({
    required this.diContainer,
    required this.onShowLogin,
    required this.onShowRegister,
  });
  Widget getAuthScreen() {
    return AuthScreen(
      authBloc: diContainer.resolve<AuthBloc>(),
      onShowLogin: onShowLogin,
      onShowRegister: onShowRegister,
    );
  }
}
