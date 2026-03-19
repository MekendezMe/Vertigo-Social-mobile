import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/environment/environment.dart';

class EnvironmentAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton((container) => Environment());
  }
}
