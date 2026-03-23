import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/authentication/register/logic/bloc/register_bloc.dart';
import 'package:social_network_flutter/common/authentication/register/ui/widgets/register_screen.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class RegisterCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Function() onShowMain;

  RegisterCoordinator({required this.diContainer, required this.onShowMain});
  void showRegisterScreen({required BuildContext context}) {
    push(
      context: context,
      page: RegisterScreen(
        registerBloc: diContainer.resolve<RegisterBloc>(),
        onShowMain: onShowMain,
      ),
    );
  }
}
