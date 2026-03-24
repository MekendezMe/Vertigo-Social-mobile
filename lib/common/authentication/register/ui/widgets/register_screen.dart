import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/register/logic/bloc/register_bloc.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/app_bar/main_app_bar.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.registerBloc,
    required this.onShowMain,
  });
  final RegisterBloc registerBloc;
  final Function() onShowMain;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _obscureText = true;
  String _emailErrorText = "";
  String _passwordErrorText = "";
  String _nameErrorText = "";
  String _usernameErrorText = "";
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: appBar(context),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        bloc: widget.registerBloc,
        listener: (context, state) {
          if (state is RegisterSuccess) {
            widget.onShowMain.call();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  mainTextField(
                    context: context,
                    controller: emailController,
                    labelText: "Email*",
                    hintText: "example@mail.com",
                    prefixIcon: Icon(Icons.email),
                    style: theme.textTheme.bodyMedium!,
                    errorText: _emailErrorText,
                    onChanged: _emailOnChanged,
                  ),
                  SizedBox(height: 40),
                  mainTextField(
                    context: context,
                    controller: passwordController,
                    labelText: "Password*",
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
                  SizedBox(height: 40),
                  mainTextField(
                    context: context,
                    controller: nameController,
                    labelText: "Name*",
                    style: theme.textTheme.bodyMedium!,
                    errorText: _nameErrorText,
                    onChanged: _nameOnChanged,
                  ),
                  SizedBox(height: 40),
                  mainTextField(
                    context: context,
                    controller: usernameController,
                    labelText: "Username",
                    style: theme.textTheme.bodyMedium!,
                    errorText: _usernameErrorText,
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: mainButton(
                      context: context,
                      child: Text(
                        "Регистрация",
                        style: theme.textTheme.bodyMedium!.modify(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onTap: _onRegister,
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

  void _nameOnChanged(String value) {
    setState(() {
      _nameErrorText = "";
    });
  }

  void _onRegister() {
    if (!_isCorrectData()) return;
    widget.registerBloc.add(
      Register(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        username: usernameController.text,
      ),
    );
  }

  bool _isCorrectData() {
    final isEmailValid = _isCorrectEmail();
    final isPasswordValid = _isCorrectPassword();
    final isNameValid = _isCorrectName();

    return isEmailValid && isPasswordValid && isNameValid;
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
    if (passwordController.text.length < 3) {
      setState(() {
        _passwordErrorText = "Пароль должен быть минимум из 3 символов";
      });
      return false;
    }
    _passwordErrorText = "";
    return true;
  }

  bool _isCorrectName() {
    if (nameController.text.isEmpty) {
      setState(() {
        _nameErrorText = "Данное поле обязательно";
      });
      return false;
    }
    _passwordErrorText = "";
    return true;
  }
}
