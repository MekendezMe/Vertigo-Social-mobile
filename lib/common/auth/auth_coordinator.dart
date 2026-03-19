import 'package:flutter/widgets.dart';
import 'package:social_network_flutter/common/auth/logic/bloc/auth_bloc.dart';
import 'package:social_network_flutter/common/auth/ui/screens/auth_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class AuthCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;

  AuthCoordinator({required this.diContainer});
  Widget getAuthScreen() {
    return AuthScreen(authBloc: diContainer.resolve<AuthBloc>());
  }
}
