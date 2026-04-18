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
  try {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;
    final userService = diContainer.resolve<UserService>();
    if (userService.currentUser == null) return;

    final parts = payload.split(':');
    final type = parts[0];

    switch (type) {
      // case 'post':
      //   break;

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
}

// void _handleNotificationNavigation(String payload) {
//   try {
//     _retryNavigation(payload, 0);
//   } catch (e) {
//     return;
//   }
// }

// void _retryNavigation(String payload, int attempt) {
//   if (attempt > 500) {
//     return;
//   }

//   Future.delayed(Duration(milliseconds: 100), () {
//     final context = NavigationService.navigatorKey.currentContext;
//     final userService = diContainer.resolve<UserService>();

//     if (context != null && userService.currentUser != null) {
//       final parts = payload.split(':');
//       final type = parts[0];

//       switch (type) {
//         case 'comment':
//           final postId = int.parse(parts[1]);
//           commentCoordinator.onShowCommentScreen(
//             context: context,
//             postId: postId,
//           );
//           break;
//       }
//     } else {
//       _retryNavigation(payload, attempt + 1);
//     }
//   });
// }

final mainCoordinator = FeedCoordinator(
  diContainer: diContainer,
  onShowProfile: ({required BuildContext context}) => {"qwe": "qq"},
  onShowSettings: ({required BuildContext context}) => {"qwe": "qq"},
  onShowComments: ({required BuildContext context, required int postId}) =>
      commentCoordinator.onShowCommentScreen(context: context, postId: postId),
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
    FeedAssembly(),
    AuthInterceptorAssembly(),
    CommentAssembly(),
  ]);
}
