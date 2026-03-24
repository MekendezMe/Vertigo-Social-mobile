import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/screens/feed_screen.dart';

class FeedCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Function({required BuildContext context}) onShowProfile;
  final Function({required BuildContext context}) onShowSettings;

  FeedCoordinator({
    required this.diContainer,
    required this.onShowProfile,
    required this.onShowSettings,
  });

  Widget showMain() {
    return FeedScreen(
      feedBloc: diContainer.resolve<FeedBloc>(),
      onShowProfile: onShowProfile,
      onShowSettings: onShowSettings,
    );
  }
}
