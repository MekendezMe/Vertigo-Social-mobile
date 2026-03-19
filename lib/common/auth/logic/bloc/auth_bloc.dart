import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/auth/logic/entities/register_request.dart';
import 'package:social_network_flutter/common/auth/logic/entities/register_response_dto.dart';
import 'package:social_network_flutter/common/auth/logic/repository/auth_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository, required this.talker})
    : super(AuthInitial()) {
    on<Authorize>(_onAuthorize);
    on<Register>(_onRegister);
  }

  final AuthRepository authRepository;
  final Talker talker;

  Future<void> _onAuthorize(Authorize event, Emitter<AuthState> emit) async {}

  Future<void> _onRegister(Register event, Emitter<AuthState> emit) async {
    try {
      if (state is! RegisterLoadingSuccess) {
        emit(RegisterLoading());
      }

      final response = await authRepository.register(
        RegisterRequest(
          name: event.name,
          email: event.email,
          password: event.password,
          username: event.username,
        ),
      );
      emit(
        RegisterLoadingSuccess(
          response: RegisterResponseDto(
            userId: response.userId,
            name: response.name,
            username: response.username,
          ),
        ),
      );
    } catch (e, st) {
      talker.handle(e, st);
      emit(RegisterFailure(error: e));
    }
  }
}
