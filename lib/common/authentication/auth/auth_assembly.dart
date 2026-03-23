import 'package:social_network_flutter/common/authentication/auth/logic/bloc/auth_bloc.dart';
import 'package:social_network_flutter/common/authentication/auth/logic/repository/auth_repository.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';

class AuthAssembly implements DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton((container) => AuthRepository());
    container.registerFactory((container) => AuthBloc());
  }
}
