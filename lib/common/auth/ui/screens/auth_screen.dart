import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/auth/logic/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.authBloc});
  final AuthBloc authBloc;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthorizeLoading) {
            return CircularProgressIndicator();
          }
          if (state is AuthorizeLoadingSuccess) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text("qq"),
            );
          }
          return Container();
        },
      ),
    );
  }
}
