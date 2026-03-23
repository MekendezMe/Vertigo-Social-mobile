import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/feed/logic/repository/feed_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;
  final Talker talker;
  final ErrorHandler errorHandler;
  FeedBloc({
    required this.feedRepository,
    required this.talker,
    required this.errorHandler,
  }) : super(FeedInitial()) {
    on<FeedEvent>((event, emit) {});
  }
}
