import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_coordinator.dart';
import 'package:social_network_flutter/common/framework/ui/overlay/custom_overlay_parent_widget.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_parent_widget.dart';
import 'package:social_network_flutter/common/launcher/logic/bloc/launcher_bloc.dart';
import 'package:social_network_flutter/common/launcher/ui/launcher_page.dart';

class LauncherCoordinator extends NavigationCoordinator {
  final DIContainer diContainer;
  final Widget Function() onLoggedInWidget;
  final Widget Function() onLoggedOutWidget;

  LauncherCoordinator({
    required this.onLoggedInWidget,
    required this.onLoggedOutWidget,
    required this.diContainer,
  });

  Widget getLauncherPage() {
    return CustomOverlayParentWidget(
      child: CustomToastParentWidget(
        child: LauncherPage(
          onLoggedInWidget: onLoggedInWidget,
          onLoggedOutWidget: onLoggedOutWidget,
          bloc: diContainer.resolve<LauncherBloc>(),
        ),
      ),
    );
  }
}
