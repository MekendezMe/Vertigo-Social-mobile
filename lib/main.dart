import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/auth/auth_assembly.dart';
import 'package:social_network_flutter/common/auth/auth_coordinator.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/framework_assembly.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/launcher/launcher_assembly.dart';
import 'package:social_network_flutter/common/launcher/launcher_coordinator.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _registerAssemblies();
  final talker = TalkerFlutter.init();
  FlutterError.onError = (details) =>
      talker.handle(details.exception, details.stack);
  Bloc.observer = TalkerBlocObserver(talker: talker);
  runApp(const MyApp());
}

final authCoordinator = AuthCoordinator(diContainer: diContainer);

final launcherCoordinator = LauncherCoordinator(
  diContainer: diContainer,
  onLoggedInWidget: authCoordinator.getAuthScreen, // TODO: MAIN COORDINATOR,
  onLoggedOutWidget: authCoordinator.getAuthScreen,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vertigo',
      theme: VertigoTheme.dark,
      home: launcherCoordinator.getLauncherPage(),
    );
  }
}

final diContainer = DIContainer();

void _registerAssemblies() {
  diContainer.registerAssemblies([
    FrameworkAssembly(),
    LauncherAssembly(),
    AuthAssembly(),
  ]);
}
