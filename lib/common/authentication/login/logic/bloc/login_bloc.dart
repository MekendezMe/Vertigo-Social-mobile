import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/login/logic/entities/login_request.dart';
import 'package:social_network_flutter/common/authentication/login/logic/repository/login_repository.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.loginRepository,
    required this.talker,
    required this.errorHandler,
  }) : super(LoginInitial()) {
    on<Login>(_onLogin);
  }

  final LoginRepository loginRepository;
  final Talker talker;
  final ErrorHandler errorHandler;

  Future<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    try {
      emit(Logining());
      final response = await loginRepository.login(
        LoginRequest(email: event.email, password: event.password),
      );
      emit(LoginSuccess());
    } catch (e, st) {
      emit(LoginFailure(error: e));
      errorHandler.handle(e);
      talker.handle(e, st);
    }
  }
}
