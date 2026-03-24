import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/login/logic/bloc/login_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.loginBloc,
    required this.onShowMain,
    required this.onShowForgotPassword,
  });
  final LoginBloc loginBloc;
  final Function() onShowMain;
  final Function({required BuildContext context}) onShowForgotPassword;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  String _emailErrorText = "";
  String _passwordErrorText = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: appBar(context),
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: widget.loginBloc,
        listener: (context, state) {
          if (state is LoginSuccess) {
            widget.onShowMain.call();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                children: [
                  SizedBox(height: 150),
                  mainTextField(
                    context: context,
                    controller: emailController,
                    labelText: "Email",
                    hintText: "example@mail.com",
                    prefixIcon: Icon(Icons.email),
                    style: theme.textTheme.bodyMedium!,
                    errorText: _emailErrorText,
                    onChanged: _emailOnChanged,
                  ),
                  SizedBox(height: 50),
                  mainTextField(
                    context: context,
                    controller: passwordController,
                    labelText: "Password",
                    prefixIcon: Icon(Icons.password),
                    style: theme.textTheme.bodyMedium!,
                    obscureText: _obscureText,
                    errorText: _passwordErrorText,
                    onChanged: _passwordOnChanged,
                    onSuffixIconPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: mainButton(
                      context: context,
                      child: Text(
                        "Вход",
                        style: theme.textTheme.bodyMedium!.modify(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onTap: _onLogin,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _emailOnChanged(String value) {
    setState(() {
      _emailErrorText = "";
    });
  }

  void _passwordOnChanged(String value) {
    setState(() {
      _passwordErrorText = "";
    });
  }

  void _onLogin() {
    if (!_isCorrectData()) return;
    widget.loginBloc.add(
      Login(email: emailController.text, password: passwordController.text),
    );
  }

  bool _isCorrectData() {
    final isEmailValid = _isCorrectEmail();
    final isPasswordValid = _isCorrectPassword();
    return isEmailValid && isPasswordValid;
  }

  bool _isCorrectEmail() {
    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      setState(() {
        _emailErrorText = "Введен некорректный email";
      });

      return false;
    }
    _emailErrorText = "";
    return true;
  }

  bool _isCorrectPassword() {
    if (passwordController.text.isEmpty) {
      setState(() {
        _passwordErrorText = "Введен некорректный пароль";
      });
      return false;
    }
    _passwordErrorText = "";
    return true;
  }
}
