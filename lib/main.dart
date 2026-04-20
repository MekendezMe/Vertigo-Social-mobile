import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/authentication/user/user_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/environment/environment_assembly.dart';
import 'package:social_network_flutter/common/framework/framework_assembly.dart';
import 'package:social_network_flutter/common/framework/navigation/navigation_service.dart';
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
import 'package:social_network_flutter/firebase_options.dart';
import 'package:social_network_flutter/post/logic/bloc/post_bloc.dart';
import 'package:social_network_flutter/post/logic/bloc/post_composer_bloc.dart';
import 'package:social_network_flutter/post/post_assembly.dart';
import 'package:social_network_flutter/post/post_coordinator.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerAssemblies();
  final talker = TalkerFlutter.init();
  FlutterError.onError = (details) =>
      talker.handle(details.exception, details.stack);
  Bloc.observer = TalkerBlocObserver(talker: talker);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final messaging = FirebaseMessaging.instance;
  print(await messaging.getToken());
  final notificationService = diContainer.resolve<NotificationService>();
  await notificationService.init();

  notificationService.onNotificationTap = (payload) {
    handleNotificationNavigation(payload);
  };

  // final String? pendingPayload = await notificationService
  //     .getPendingNotification();
  // if (pendingPayload != null) {
  //   _handleNotificationNavigation(pendingPayload);
  // }
  runApp(MyApp());
}

void handleNotificationNavigation(String payload) {
  final trimmed = payload.trim();
  if (trimmed.isEmpty) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      final context = NavigationService.navigatorKey.currentContext;
      if (context == null) return;
      final userService = diContainer.resolve<UserService>();
      if (userService.currentUser == null) return;

      final parts = trimmed.split(':');
      final type = parts[0];

      switch (type) {
        case 'post':
          final postId = int.parse(parts[1]);
          postCoordinator.onShowPostScreen(context: context, postId: postId);
          break;

        case 'comment':
          final postId = int.parse(parts[1]);
          commentCoordinator.onShowCommentScreen(
            context: context,
            postId: postId,
          );
          break;

        // case 'profile':
        //   final userId = int.parse(parts[1]);
        //   diContainer.resolve<ProfileCoordinator>().showProfile(context, userId);
        //   break;
      }
    } catch (e) {
      return;
    }
  });
}

final mainCoordinator = FeedCoordinator(
  diContainer: diContainer,
  onShowProfile: ({required BuildContext context}) => {"qwe": "qq"},
  onShowSettings: ({required BuildContext context}) => {"qwe": "qq"},
  onShowComments: ({required BuildContext context, required int postId}) =>
      commentCoordinator.onShowCommentScreen(context: context, postId: postId),
  onShowPost: ({required BuildContext context, required int postId}) =>
      postCoordinator.onShowPostScreen(context: context, postId: postId),
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

final postCoordinator = PostCoordinator(
  diContainer: diContainer,
  showCommentScreen: ({required int postId}) =>
      commentCoordinator.showCommentScreen(postId: postId),
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
        BlocProvider(create: (context) => diContainer.resolve<PostBloc>()),
        BlocProvider(
          create: (context) => diContainer.resolve<PostComposerBloc>(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
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
    PostAssembly(),
    FeedAssembly(),
    AuthInterceptorAssembly(),
    CommentAssembly(),
  ]);
}
