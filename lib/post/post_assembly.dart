import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/media/media_service.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/feed/logic/repository/feed_repository.dart';
import 'package:social_network_flutter/post/logic/bloc/post_bloc.dart';
import 'package:social_network_flutter/post/logic/bloc/post_composer_bloc.dart';
import 'package:social_network_flutter/post/logic/repository/post_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PostAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) =>
          PostRepository(requestSender: container.resolve<RequestSender>()),
    );

    container.registerSingleton(
      (container) => PostBloc(
        postRepository: container.resolve<PostRepository>(),
        errorHandler: container.resolve<ErrorHandler>(),
        talker: container.resolve<Talker>(),
        userService: container.resolve<UserService>(),
      ),
    );

    container.registerFactory(
      (container) => PostComposerBloc(
        postRepository: container.resolve<PostRepository>(),
        feedRepository: container.resolve<FeedRepository>(),
        errorHandler: container.resolve<ErrorHandler>(),
        mediaService: container.resolve<MediaService>(),
        talker: container.resolve<Talker>(),
      ),
    );
  }
}
