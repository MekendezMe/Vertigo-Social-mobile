import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/media/media_service.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/common/framework/notifications/notification_service.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
import 'package:social_network_flutter/comment/logic/repository/comment_repository.dart';
import 'package:social_network_flutter/feed/logic/repository/feed_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FeedAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) => FeedRepository(
        requestSender: container.resolve<RequestSender>(),
        talker: container.resolve<Talker>(),
      ),
    );

    container.registerSingleton(
      (container) => FeedBloc(
        feedRepository: container.resolve<FeedRepository>(),
        talker: container.resolve<Talker>(),
        errorHandler: container.resolve<ErrorHandler>(),
        userService: container.resolve<UserService>(),
        permissionService: container.resolve<PermissionService>(),
        notificationService: container.resolve<INotificationService>(),
        mediaService: container.resolve<MediaService>(),
      ),
    );
  }
}
