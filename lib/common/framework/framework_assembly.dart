import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FrameworkAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton<IPreferencesStorage>(
      (container) => PreferencesStorage(),
    );
    container.registerSingleton<ISecureStorage>((container) => SecureStorage());
    container.registerSingleton((container) => Talker());
  }
}
