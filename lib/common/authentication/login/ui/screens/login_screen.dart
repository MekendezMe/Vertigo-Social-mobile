import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/login/logic/bloc/login_bloc.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.loginBloc,
    required this.onShowMain,
    required this.onShowForgotPassword,
  });
  final LoginBloc loginBloc;
  final Function({required BuildContext context}) onShowMain;
  final Function({required BuildContext context}) onShowForgotPassword;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = context.theme;
    return Scaffold(
      appBar: appBar(context),
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: widget.loginBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Text("qq"),
          );
        },
      ),
    );
  }
}
