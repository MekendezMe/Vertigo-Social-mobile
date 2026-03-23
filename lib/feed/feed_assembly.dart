import 'package:social_network_flutter/common/framework/di/di_assembly.dart';
import 'package:social_network_flutter/common/framework/di/di_container.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/network/request_sender.dart';
import 'package:social_network_flutter/feed/logic/bloc/feed_bloc.dart';
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

    container.registerFactory(
      (container) => FeedBloc(
        feedRepository: container.resolve<FeedRepository>(),
        talker: container.resolve<Talker>(),
        errorHandler: container.resolve<ErrorHandler>(),
      ),
    );
  }
}
