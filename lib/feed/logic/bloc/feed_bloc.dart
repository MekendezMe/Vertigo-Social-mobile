import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/media/media_service.dart';
import 'package:social_network_flutter/common/framework/notifications/notification_service.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
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
  final UserService userService;
  final PermissionService permissionService;
  final INotificationService notificationService;
  final MediaService mediaService;
  FeedBloc({
    required this.feedRepository,
    required this.talker,
    required this.errorHandler,
    required this.userService,
    required this.permissionService,
    required this.notificationService,
    required this.mediaService,
  }) : super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMorePosts>(_onLoadMorePosts);

    on<CreatePost>(_onCreatePost);

    on<ToggleLike>(_onToggleLike);

    on<PickImageFromCamera>(_onPickImageFromCamera);
    on<PickImagesFromGallery>(_onPickImagesFromGallery);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    try {
      emit(FeedLoading());
      final response = await feedRepository.getPosts(
        GetPostsRequest(pageNumber: event.pageNumber ?? 1),
      );
      if (userService.currentUser == null) {
        throw AuthException();
      }
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
      final response = await feedRepository.getPosts(
        GetPostsRequest(pageNumber: event.pageNumber),
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
      emit(current.copyWith(isLoadingMore: false));
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
        CreatePostRequest(text: event.text, images: event.images),
      );
      emit(
        currentState.copyWith(
          posts: [createdPost.post, ...currentState.posts],
          isCreating: false,
          createError: null,
          images: null,
        ),
      );
      final canSend = await permissionService.canSendNotifications();
      if (canSend) {
        await notificationService.showNotification(
          title: 'Добро пожаловать!',
          body: 'Вы успешно вошли в приложение',
        );
      }
    } catch (e, st) {
      emit(currentState.copyWith(isCreating: false, createError: e.toString()));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onToggleLike(ToggleLike event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;

    final targetPost = currentState.posts.firstWhere(
      (post) => post.id == event.postId,
    );
    final willLike = !targetPost.likedByUser;
    final delta = willLike ? 1 : -1;
    final errorMessage = willLike
        ? "Не удалось поставить лайк"
        : "Не удалось убрать лайк";
    final originalPost = targetPost;

    final optimisticPosts = currentState.posts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(
          likesCount: post.likesCount + delta,
          likedByUser: willLike,
        );
      }
      return post;
    }).toList();

    emit(currentState.copyWith(posts: optimisticPosts, likeError: null));

    try {
      final response = willLike
          ? await feedRepository.likePost(
              LikePostRequest(
                userId: userService.currentUserId,
                postId: event.postId,
              ),
            )
          : await feedRepository.unlikePost(
              UnlikePostRequest(
                userId: userService.currentUserId,
                postId: event.postId,
              ),
            );

      if (!response.success) {
        final rolledBackPosts = _getRolledBackPosts(
          postId: event.postId,
          originalPost: originalPost,
          currentState: currentState,
        );
        emit(
          currentState.copyWith(
            posts: rolledBackPosts,
            likeError: errorMessage,
          ),
        );
        throw ApiException(message: errorMessage);
      }
    } catch (e, st) {
      final rolledBackPosts = _getRolledBackPosts(
        postId: event.postId,
        originalPost: originalPost,
        currentState: currentState,
      );
      emit(
        currentState.copyWith(posts: rolledBackPosts, likeError: errorMessage),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  List<Post> _getRolledBackPosts({
    required int postId,
    required Post originalPost,
    required FeedLoaded currentState,
  }) {
    return currentState.posts.map((post) {
      if (post.id == postId) {
        return originalPost;
      }
      return post;
    }).toList();
  }

  Future<void> _onPickImageFromCamera(
    PickImageFromCamera event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;

    emit(currentState.copyWith(isImageLoading: true));

    try {
      final image = await mediaService.takePhotoWithPermission();
      if (image != null) {
        emit(currentState.copyWith(images: [image], isImageLoading: false));
      } else {
        emit(currentState.copyWith(isImageLoading: false));
      }
    } catch (e, st) {
      emit(currentState.copyWith(isImageLoading: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onPickImagesFromGallery(
    PickImagesFromGallery event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;

    emit(currentState.copyWith(isImageLoading: true));

    try {
      final images = await mediaService.pickPhotosWithPermission();
      if (images != null && images.isNotEmpty) {
        emit(currentState.copyWith(images: images, isImageLoading: false));
      } else {
        emit(currentState.copyWith(isImageLoading: false));
      }
    } catch (e, st) {
      emit(currentState.copyWith(isImageLoading: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }
}
