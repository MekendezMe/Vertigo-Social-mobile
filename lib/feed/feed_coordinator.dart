import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/feed/ui/screens/feed_screen.dart';

class FeedCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;

  FeedCoordinator({required this.diContainer});

  Widget showMain() {
    return FeedScreen(feedBloc: diContainer.resolve<FeedBloc>());
  }
}
