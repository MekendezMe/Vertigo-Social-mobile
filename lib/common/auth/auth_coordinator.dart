import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';

class AuthCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;

  AuthCoordinator({required this.diContainer});
}
