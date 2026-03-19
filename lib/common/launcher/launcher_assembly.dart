import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:social_network_flutter/common/launcher/logic/bloc/launcher_bloc.dart';

class LauncherAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) => LauncherBloc(
        preferencesStorage: container.resolve<IPreferencesStorage>(),
        secureStorage: container.resolve<ISecureStorage>(),
      ),
    );
  }
}
