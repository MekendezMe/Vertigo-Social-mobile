import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/register/entities/register_request.dart';
import 'package:social_network_flutter/common/authentication/register/logic/repository/register_repository.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/entities/request/save_token_request.dart';
import 'package:social_network_flutter/common/launcher/logic/repository/launcher_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required this.registerRepository,
    required this.talker,
    required this.errorHandler,
    required this.launcherRepository,
    required this.preferencesStorage,
  }) : super(RegisterInitial()) {
    on<Register>(_onRegister);
  }

  final RegisterRepository registerRepository;
  final LauncherRepository launcherRepository;
  final IPreferencesStorage preferencesStorage;
  final Talker talker;
  final ErrorHandler errorHandler;

  Future<void> _onRegister(Register event, Emitter<RegisterState> emit) async {
    try {
      emit(Registering());
      await registerRepository.register(
        RegisterRequest(
          name: event.name,
          email: event.email,
          password: event.password,
          username: event.username,
        ),
      );
      await _saveFcmToken();
      emit(RegisterSuccess());
    } catch (e, st) {
      emit(RegisterFailure(error: e));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _saveFcmToken() async {
    final token = preferencesStorage.fcmToken;
    if (token == null) {
      return;
    }
    await launcherRepository.saveToken(SaveTokenRequest(fcmToken: token));
  }
}
