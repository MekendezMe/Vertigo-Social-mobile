import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/register/entities/register_request.dart';
import 'package:social_network_flutter/common/authentication/register/logic/repository/register_repository.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required this.registerRepository,
    required this.talker,
    required this.errorHandler,
  }) : super(RegisterInitial()) {
    on<Register>(_onRegister);
  }

  final RegisterRepository registerRepository;
  final Talker talker;
  final ErrorHandler errorHandler;

  Future<void> _onRegister(Register event, Emitter<RegisterState> emit) async {
    try {
      final response = await registerRepository.register(
        RegisterRequest(
          name: event.name,
          email: event.email,
          password: event.password,
          username: event.username,
        ),
      );
      emit(
        RegisterSuccess(
          userId: response.userId,
          name: response.name,
          username: response.username,
        ),
      );
    } catch (e, st) {
      emit(RegisterFailure(error: e));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }
}
