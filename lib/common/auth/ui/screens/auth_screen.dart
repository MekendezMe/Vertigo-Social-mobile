import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network_flutter/common/auth/logic/bloc/auth_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.authBloc});
  final AuthBloc authBloc;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset("assets/logo.png", width: 240, height: 240),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: widget.authBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthorizeLoading) {
            return CircularProgressIndicator();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text(
                        "Узнайте, что происходит в мире прямо сейчас.",
                        style: theme.textTheme.displayMedium!.modify(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.fjallaOne().fontFamily,
                        ),
                        softWrap: true,
                      ),
                      SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.color.purple,
                          ),
                          child: Text(
                            "Зарегистрироваться",
                            style: theme.textTheme.bodyMedium!.modify(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        "Уже есть учетная запись?",
                        style: theme.textTheme.bodyMedium!,
                      ),
                      SizedBox(width: 6),
                      Text("Войти", style: context.textStyle.urlText),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
