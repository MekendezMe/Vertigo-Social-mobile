import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/authentication/register/logic/bloc/register_bloc.dart';
import 'package:social_network_flutter/common/authentication/register/ui/screens/register_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class RegisterCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Widget Function() showMain;

  RegisterCoordinator({required this.diContainer, required this.showMain});
  void showRegisterScreen({required BuildContext context}) {
    push(
      context: context,
      page: RegisterScreen(
        registerBloc: diContainer.resolve<RegisterBloc>(),
        onShowMain: onShowMain,
      ),
    );
  }

  void onShowMain({required BuildContext context}) {
    pushReplacement(context: context, page: showMain());
  }
}
