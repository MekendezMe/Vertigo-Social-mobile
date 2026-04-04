import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/comment/logic/repository/comment_repository.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CommentAssembly extends DIAssembly {
  @override
  assembly(DIContainer container) {
    container.registerSingleton(
      (container) =>
          CommentRepository(requestSender: container.resolve<RequestSender>()),
    );

    container.registerSingleton(
      (container) => CommentBloc(
        commentRepository: container.resolve<CommentRepository>(),
        talker: container.resolve<Talker>(),
        errorHandler: container.resolve<ErrorHandler>(),
        userService: container.resolve<UserService>(),
      ),
    );
  }
}
