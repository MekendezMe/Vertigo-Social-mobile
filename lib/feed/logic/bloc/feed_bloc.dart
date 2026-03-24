import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/request/get_posts_request.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
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
    on<LoadFeed>((event, emit) async {
      try {
        if (state is! FeedLoaded || state is FeedInitial) {
          emit(FeedLoading());
        }
        final response = await feedRepository.getPosts(GetPostsRequest());
        emit(FeedLoaded(posts: response.posts, user: response.user));
      } catch (e, st) {
        emit(FeedLoadingFailure(error: e));
        talker.handle(e, st);
        errorHandler.handle(e);
      }
    });
  }
}
