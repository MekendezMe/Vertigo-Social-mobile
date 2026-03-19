import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/launcher/logic/bloc/launcher_bloc.dart';

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
  @override
  void initState() {
    super.initState();
    widget.bloc.add(Initialize());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LauncherBloc, LauncherState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is LauncherLoggedIn) {
          return widget.onLoggedInWidget();
        }

        if (state is LauncherLoggedOut) {
          return widget.onLoggedOutWidget();
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
