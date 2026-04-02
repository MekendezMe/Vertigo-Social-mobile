import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/launcher/logic/bloc/launcher_bloc.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';

class LauncherPage extends StatefulWidget {
  final Widget Function() onLoggedInWidget;
  final Widget Function() onLoggedOutWidget;
  final LauncherBloc bloc;
  const LauncherPage({
    super.key,
    required this.onLoggedInWidget,
    required this.onLoggedOutWidget,
    required this.bloc,
  });

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  final _loggedInKey = GlobalKey<NavigatorState>();
  final _loggedOutKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState>? _currentStateKey;

  @override
  void dispose() {
    print("🔴 [LauncherPage] dispose() ВЫЗВАН");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.bloc.add(Initialize());
  }

  @override
  Widget build(BuildContext context) {
    return _buildBackButtonHandler(
      context: context,
      child: BlocConsumer<LauncherBloc, LauncherState>(
        bloc: widget.bloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LauncherLoggedIn) {
            return _buildNavigatorStack(
              _loggedInKey,
              (context) => widget.onLoggedInWidget(),
            );
          }

          if (state is LauncherLoggedOut) {
            return _buildNavigatorStack(
              _loggedOutKey,
              (context) => widget.onLoggedOutWidget(),
            );
          }

          return Scaffold(
            body: Center(
              child: customCircularProgressIndicator(context: context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButtonHandler({
    required BuildContext context,
    required Widget child,
  }) {
    if (Platform.isIOS) {
      return child;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        final didPopResult =
            await _currentStateKey?.currentState?.maybePop() ?? false;
        if (!didPopResult) {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }

  Widget _buildNavigatorStack(
    GlobalKey<NavigatorState> key,
    WidgetBuilder widgetBuilder,
  ) {
    _currentStateKey = key;
    return Navigator(
      initialRoute: '/',
      key: key,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: widgetBuilder, settings: settings);
      },
    );
  }
}
