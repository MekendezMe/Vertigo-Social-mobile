import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/post/logic/entities/post_types.dart';
import 'package:social_network_flutter/post/logic/entities/request/request/get_posts_request.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/feed/logic/repository/feed_repository.dart';
import 'package:social_network_flutter/post/logic/repository/post_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;
  final PostRepository postRepository;
  final Talker talker;
  final ErrorHandler errorHandler;
  final UserService userService;
  final PermissionService permissionService;
  FeedBloc({
    required this.feedRepository,
    required this.talker,
    required this.errorHandler,
    required this.userService,
    required this.permissionService,
    required this.postRepository,
  }) : super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<ChangeFeedType>(_onChangeFeedType);
    on<AddPostToTop>(_onAddPostToTop);
    on<ReplacePostInFeed>(_onReplacePostInFeed);
    on<RemovePostFromFeed>(_onRemovePostFromFeed);
    on<MarkUserSubscribedInFeed>(_onMarkUserSubscribedInFeed);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    try {
      emit(FeedLoading());
      final response = await postRepository.getPosts(
        GetPostsRequest(pageNumber: event.pageNumber ?? 1),
      );
      if (userService.currentUser == null) {
        throw AuthException();
      }
      await permissionService.requestNotificationIfNeeded();
      emit(
        FeedLoaded(
          posts: response.posts,
          user: userService.currentUser!,
          isLastPage: response.isLastPage,
        ),
      );
    } catch (e, st) {
      emit(FeedLoadingFailure(error: e));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePosts event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final current = state as FeedLoaded;
    try {
      emit(current.copyWith(isLoadingMore: true));
      final response = await postRepository.getPosts(
        GetPostsRequest(pageNumber: event.pageNumber, type: event.type),
      );
      emit(
        current.copyWith(
          isLoadingMore: false,
          posts: [...current.posts, ...response.posts],
          currentPage: event.pageNumber,
          isLastPage: response.isLastPage,
        ),
      );
    } catch (e, st) {
      emit(current.copyWith(isLoadingMore: false, isLastPage: true));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onChangeFeedType(
    ChangeFeedType event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    if (currentState.currentType == event.type) {
      return;
    }
    final currentPage = 1;
    try {
      final response = await postRepository.getPosts(
        GetPostsRequest(pageNumber: currentPage, type: event.type),
      );
      emit(
        currentState.copyWith(
          posts: [...response.posts],
          currentPage: currentPage,
          isLastPage: response.isLastPage,
          currentType: event.type,
        ),
      );
    } catch (e, st) {
      emit(currentState.copyWith(currentPage: currentPage, isLastPage: true));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onAddPostToTop(
    AddPostToTop event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    final withoutDuplicate = currentState.posts
        .where((post) => post.id != event.post.id)
        .toList();
    emit(currentState.copyWith(posts: [event.post, ...withoutDuplicate]));
  }

  Future<void> _onReplacePostInFeed(
    ReplacePostInFeed event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    final index = currentState.posts.indexWhere((p) => p.id == event.post.id);
    if (index == -1) return;
    final updatedPosts = List<Post>.from(currentState.posts);
    updatedPosts[index] = event.post;
    emit(currentState.copyWith(posts: updatedPosts));
  }

  Future<void> _onRemovePostFromFeed(
    RemovePostFromFeed event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    final updatedPosts = currentState.posts
        .where((post) => post.id != event.postId)
        .toList();
    emit(currentState.copyWith(posts: updatedPosts));
  }

  Future<void> _onMarkUserSubscribedInFeed(
    MarkUserSubscribedInFeed event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    final updatedPosts = currentState.posts
        .map(
          (post) => post.creator.id == event.userId
              ? post.copyWith(subscribedByUser: true)
              : post,
        )
        .toList();
    emit(currentState.copyWith(posts: updatedPosts));
  }
}
