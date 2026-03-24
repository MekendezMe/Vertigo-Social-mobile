import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/request/create_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/get_posts_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/like_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/unlike_post_request.dart';
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
    on<LoadFeed>(_onLoadFeed);

    on<CreatePost>(_onCreatePost);

    on<LikePost>(_onLikePost);

    on<UnlikePost>(_onUnlikePost);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    try {
      emit(FeedLoading());
      final response = await feedRepository.getPosts(GetPostsRequest());
      emit(FeedLoaded(posts: response.posts, user: response.user));
    } catch (e, st) {
      emit(FeedLoadingFailure(error: e));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    try {
      emit(currentState.copyWith(isCreating: true));
      final createdPost = await feedRepository.createPost(
        CreatePostRequest(userId: event.userId, text: event.text),
      );
      emit(
        currentState.copyWith(
          posts: [createdPost.post, ...currentState.posts],
          isCreating: false,
        ),
      );
    } catch (e, st) {
      emit(currentState.copyWith(isCreating: false, createError: e.toString()));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onLikePost(LikePost event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    try {
      emit(currentState.copyWith(isLiking: true));
      final likeSuccess = await feedRepository.likePost(
        LikePostRequest(userId: event.userId, postId: event.postId),
      );
      if (!likeSuccess.success) {
        emit(
          currentState.copyWith(
            isLiking: false,
            likeError: "Не удалось поставить лайк",
          ),
        );
      }
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(
            likesCount: post.likesCount + 1,
            likedByUser: true,
          );
        }
        return post;
      }).toList();
      emit(currentState.copyWith(posts: updatedPosts, isLiking: false));
    } catch (e, st) {
      emit(currentState.copyWith(isLiking: false, likeError: e.toString()));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onUnlikePost(UnlikePost event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    try {
      emit(currentState.copyWith(isLiking: true));
      final unlikeSuccess = await feedRepository.unlikePost(
        UnlikePostRequest(userId: event.userId, postId: event.postId),
      );
      if (!unlikeSuccess.success) {
        emit(
          currentState.copyWith(
            isLiking: false,
            likeError: "Не удалось убрать лайк",
          ),
        );
      }
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(
            likesCount: post.likesCount - 1,
            likedByUser: false,
          );
        }
        return post;
      }).toList();
      emit(currentState.copyWith(posts: updatedPosts, isLiking: false));
    } catch (e, st) {
      emit(currentState.copyWith(isLiking: false, likeError: e.toString()));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }
}
