import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network_flutter/common/authentication/auth/logic/bloc/auth_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/buttons/main_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.authBloc,
    required this.onShowLogin,
    required this.onShowRegister,
  });
  final AuthBloc authBloc;
  final Function({required BuildContext context}) onShowLogin;
  final Function({required BuildContext context}) onShowRegister;
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
      appBar: appBar(context),
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
                        child: mainButton(
                          context: context,
                          onTap: () {
                            // CustomToast.show(
                            //   CustomToastWidget(text: "Переход к регистрации"),
                            //   dismissAfter: Duration(seconds: 1),
                            // );
                            widget.authBloc.add(
                              Register(
                                name: "",
                                username: "username",
                                email: "username",
                                password: "s",
                              ),
                            );
                          },
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
                      GestureDetector(
                        onTap: () => widget.onShowLogin(context: context),
                        child: Text("Войти", style: context.textStyle.urlText),
                      ),
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
