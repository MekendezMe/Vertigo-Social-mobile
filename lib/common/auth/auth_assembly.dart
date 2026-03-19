import 'package:social_network_flutter/common/auth/logic/bloc/auth_bloc.dart';
import 'package:social_network_flutter/common/auth/logic/repository/auth_repository.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AuthAssembly implements DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) => AuthRepository(
        secureStorage: container.resolve<ISecureStorage>(),
        talker: container.resolve<Talker>(),
      ),
    );
    container.registerFactory(
      (container) =>
          AuthBloc(authRepository: container.resolve<AuthRepository>()),
    );
  }
}
