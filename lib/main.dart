import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/comment_assembly.dart';
import 'package:social_network_flutter/comment/comment_coordinator.dart';
import 'package:social_network_flutter/common/authentication/auth/auth_assembly.dart';
import 'package:social_network_flutter/common/authentication/auth/auth_coordinator.dart';
import 'package:social_network_flutter/common/authentication/auth/logic/bloc/auth_bloc.dart';
import 'package:social_network_flutter/common/authentication/login/logic/bloc/login_bloc.dart';
import 'package:social_network_flutter/common/authentication/login/login_assembly.dart';
import 'package:social_network_flutter/common/authentication/login/login_coordinator.dart';
import 'package:social_network_flutter/common/authentication/register/logic/bloc/register_bloc.dart';
import 'package:social_network_flutter/common/authentication/register/register_assembly.dart';
import 'package:social_network_flutter/common/authentication/register/register_coordinator.dart';
import 'package:social_network_flutter/common/authentication/user/user_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/environment/environment_assembly.dart';
import 'package:social_network_flutter/common/framework/framework_assembly.dart';
import 'package:social_network_flutter/common/framework/network/interceptors/auth_incerteptor_assembly.dart';
import 'package:social_network_flutter/common/framework/network/network_assembly.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/common/launcher/launcher_assembly.dart';
import 'package:social_network_flutter/common/launcher/launcher_coordinator.dart';
import 'package:social_network_flutter/common/framework/notifications/notification_service.dart';
import 'package:social_network_flutter/common/launcher/logic/bloc/launcher_bloc.dart';
import 'package:social_network_flutter/feed/feed_assembly.dart';
import 'package:social_network_flutter/feed/feed_coordinator.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerAssemblies();
  final talker = TalkerFlutter.init();
  FlutterError.onError = (details) =>
      talker.handle(details.exception, details.stack);
  Bloc.observer = TalkerBlocObserver(talker: talker);
  final notificationService = diContainer.resolve<INotificationService>();
  await notificationService.init();
  runApp(const MyApp());
}

final mainCoordinator = FeedCoordinator(
  diContainer: diContainer,
  onShowProfile: ({required BuildContext context}) => {"qwe": "qq"},
  onShowSettings: ({required BuildContext context}) => {"qwe": "qq"},
  onShowComments: ({required BuildContext context}) =>
      commentCoordinator.onShowCommentScreen(context: context),
);

final commentCoordinator = CommentCoordinator(diContainer: diContainer);

final loginCoordinator = LoginCoordinator(
  diContainer: diContainer,
  showMain: mainCoordinator.showMain,
  onShowForgotPassword: ({required BuildContext context}) => {"qwe": "qq"},
);

final registerCoordinator = RegisterCoordinator(
  diContainer: diContainer,
  showMain: mainCoordinator.showMain,
);

final authCoordinator = AuthCoordinator(
  diContainer: diContainer,
  onShowLogin: ({required BuildContext context}) =>
      loginCoordinator.showLoginScreen(context: context),
  onShowRegister: ({required BuildContext context}) =>
      registerCoordinator.showRegisterScreen(context: context),
);

final launcherCoordinator = LauncherCoordinator(
  diContainer: diContainer,
  onLoggedInWidget: mainCoordinator.showMain,
  onLoggedOutWidget: authCoordinator.getAuthScreen,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => diContainer.resolve<LauncherBloc>()),
        BlocProvider(create: (context) => diContainer.resolve<AuthBloc>()),
        BlocProvider(create: (context) => diContainer.resolve<LoginBloc>()),
        BlocProvider(create: (context) => diContainer.resolve<RegisterBloc>()),
        BlocProvider(create: (context) => diContainer.resolve<FeedBloc>()),
        BlocProvider(create: (context) => diContainer.resolve<CommentBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vertigo',
        theme: VertigoTheme.dark,
        home: launcherCoordinator.getLauncherPage(),
      ),
    );
  }
}

final diContainer = DIContainer();

void _registerAssemblies() {
  diContainer.registerAssemblies([
    EnvironmentAssembly(),
    FrameworkAssembly(),
    NetworkAssembly(),
    UserAssembly(),
    LauncherAssembly(),
    AuthAssembly(),
    LoginAssembly(),
    RegisterAssembly(),
    FeedAssembly(),
    AuthInterceptorAssembly(),
    CommentAssembly(),
  ]);
}
