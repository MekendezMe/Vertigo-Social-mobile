import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/common/framework/media/media_service.dart';
import 'package:social_network_flutter/common/framework/notifications/notification_service.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';
import 'package:social_network_flutter/common/launcher/launcher_dependencies.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:social_network_flutter/feed/logic/entites/post_types.dart';
import 'package:social_network_flutter/feed/logic/entites/request/create_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/delete_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/edit_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/get_posts_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/like_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/unlike_post_request.dart';
import 'package:social_network_flutter/feed/logic/entites/request/user/subscribe_request.dart';
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
  final ILogoutHandler logoutHandler;
  FeedBloc({
    required this.feedRepository,
    required this.talker,
    required this.errorHandler,
    required this.userService,
    required this.permissionService,
    required this.notificationService,
    required this.mediaService,
    required this.logoutHandler,
  }) : super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<ChangeFeedType>(_onChangeFeedType);
    on<CreatePost>(_onCreatePost);
    on<EditPost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);

    on<ToggleLike>(_onToggleLike);

    on<PickImageFromCamera>(_onPickImageFromCamera);
    on<PickMediaFromGallery>(_onPickMediaFromGallery);
    on<RemoveMediaFromPost>(_onRemoveMediaFromPost);
    on<ClearMedia>(_onClearMedia);
    on<Subscribe>(_onSubscribe);
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
      final response = await feedRepository.getPosts(
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

  Future<void> _onCreatePost(CreatePost event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    if (currentState.isCreating) return;
    try {
      emit(currentState.copyWith(isCreating: true, isCreateSuccess: null));
      final createdPost = await feedRepository.createPost(
        CreatePostRequest(text: event.text, media: event.media),
      );
      emit(
        currentState.copyWith(
          posts: [createdPost.post, ...currentState.posts],
          isCreating: false,
          createError: null,
          media: null,
          isCreateSuccess: true,
        ),
      );
    } catch (e, st) {
      emit(
        currentState.copyWith(
          isCreating: false,
          createError: e.toString(),
          isCreateSuccess: false,
        ),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onUpdatePost(EditPost event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;

    final currentState = state as FeedLoaded;
    if (currentState.isUpdating) return;
    emit(currentState.copyWith(isUpdating: true, isUpdateSuccess: false));
    try {
      final response = await feedRepository.editPost(
        EditPostRequest(
          postId: event.postId,
          text: event.text,
          deletedMedia: event.deletedImages,
          media: event.media,
        ),
      );

      final updatedPosts = currentState.posts
          .where((post) => post.id != event.postId)
          .toList();

      emit(
        currentState.copyWith(
          posts: [response.post, ...updatedPosts],
          isUpdateSuccess: true,
          isUpdating: false,
          media: null,
        ),
      );
    } catch (e, st) {
      emit(currentState.copyWith(isUpdateSuccess: false, isUpdating: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;

    final currentState = state as FeedLoaded;
    if (currentState.isDeleting) return;
    emit(currentState.copyWith(isDeleting: true, isDeleteSuccess: false));
    try {
      final response = await feedRepository.deletePost(
        DeletePostRequest(postId: event.postId),
      );

      if (!response.success) {
        throw ApiException(
          message: "Ошибка при удалении поста. Попробуйте еще раз",
        );
      }

      final updatedPosts = currentState.posts
          .where((post) => post.id != event.postId)
          .toList();

      emit(
        currentState.copyWith(
          posts: updatedPosts,
          isDeleteSuccess: true,
          isDeleting: false,
        ),
      );
    } catch (e, st) {
      emit(currentState.copyWith(isDeleteSuccess: false, isDeleting: false));
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
          ? await feedRepository.likePost(LikePostRequest(postId: event.postId))
          : await feedRepository.unlikePost(
              UnlikePostRequest(postId: event.postId),
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

    emit(currentState.copyWith(isMediaLoading: true));

    try {
      final image = await mediaService.takePhotoWithPermission();
      if (image == null) {
        emit(currentState.copyWith(isMediaLoading: false));
        return;
      }
      final currentMedia = currentState.media ?? [];
      final totalCount = currentMedia.length + 1;

      if (totalCount > 10) {
        errorHandler.handle("Можно выбрать максимум 10 файлов");
        emit(currentState.copyWith(isMediaLoading: false));
        return;
      }

      emit(
        currentState.copyWith(
          isMediaLoading: false,
          media: [image, ...currentMedia],
        ),
      );
    } catch (e, st) {
      emit(currentState.copyWith(isMediaLoading: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onPickMediaFromGallery(
    PickMediaFromGallery event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;

    emit(currentState.copyWith(isMediaLoading: true));

    try {
      final media = await mediaService.pickMultipleMedia();

      if (media.isEmpty) {
        emit(currentState.copyWith(isMediaLoading: false));
        return;
      }

      final currentMedia = currentState.media ?? [];
      final totalCount = currentMedia.length + media.length;

      if (totalCount > 10) {
        errorHandler.handle("Можно выбрать максимум 10 файлов");
        emit(currentState.copyWith(isMediaLoading: false));
        return;
      }

      final filteredMedia = <File>[];
      for (final m in media) {
        final size = await m.length();
        if (getFileSizeInMB(size) < 10) {
          filteredMedia.add(m);
        }
      }

      if (filteredMedia.length != media.length) {
        errorHandler.handle(
          "Не удалось прикрепить файл. Размер каждого файла должен быть не больше 10 МБ",
        );
        emit(currentState.copyWith(isMediaLoading: false));
        return;
      }

      emit(
        currentState.copyWith(
          isMediaLoading: false,
          media: [...filteredMedia, ...currentMedia],
        ),
      );
    } catch (e, st) {
      emit(currentState.copyWith(isMediaLoading: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  double getFileSizeInMB(int bytes, {int fractionDigits = 2}) {
    final mb = bytes / (1024 * 1024);
    return double.parse(mb.toStringAsFixed(fractionDigits));
  }

  Future<void> _onRemoveMediaFromPost(
    RemoveMediaFromPost event,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedLoaded) return;
    final current = state as FeedLoaded;
    try {
      final currentMedia = current.media ?? [];
      final newMedia = List<File>.from(currentMedia)..removeAt(event.index);

      emit(current.copyWith(media: newMedia.isEmpty ? null : newMedia));
    } catch (e, st) {
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onClearMedia(ClearMedia event, Emitter<FeedState> emit) async {
    if (state is FeedLoaded) {
      final currentState = state as FeedLoaded;
      emit(currentState.copyWith(media: null));
    }
  }

  Future<void> _onSubscribe(Subscribe event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final current = state as FeedLoaded;
    try {
      final response = await feedRepository.subscribeToUser(
        SubscribeRequest(userId: event.userId),
      );

      if (!response.success) {
        errorHandler.handle("Не удалось оформить подписку. Попробуйте снова");
      }

      final posts = current.posts
          .map(
            (post) => post.creator.id == event.userId
                ? post.copyWith(subscribedByUser: true)
                : post,
          )
          .toList();

      emit(current.copyWith(posts: posts, isSuccessSubscribed: true));
    } catch (e, st) {
      emit(current.copyWith(isSuccessSubscribed: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }
}
