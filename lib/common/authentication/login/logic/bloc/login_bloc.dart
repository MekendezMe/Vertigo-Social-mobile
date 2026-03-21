import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<Authorize>(_onAuthorize);
  }

  final LoginRepository loginRepository;
  final Talker talker;
  final ErrorHandler errorHandler;

  Future<void> _onAuthorize(Authorize event, Emitter<LoginState> emit) async {
    try {} catch (e, st) {
      errorHandler.handle(e);
      talker.handle(e, st);
    }
  }
}
