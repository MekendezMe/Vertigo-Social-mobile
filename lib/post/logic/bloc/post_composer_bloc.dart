import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/feed/logic/entites/request/user/subscribe_request.dart';
import 'package:social_network_flutter/feed/logic/repository/feed_repository.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/media/media_service.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/post/logic/entities/request/create_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/delete_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/edit_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/like_post_request.dart';
import 'package:social_network_flutter/post/logic/entities/request/unlike_post_request.dart';
import 'package:social_network_flutter/post/logic/repository/post_repository.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'post_composer_event.dart';
part 'post_composer_state.dart';

class PostComposerBloc extends Bloc<PostComposerEvent, PostComposerState> {
  PostComposerBloc({
    required this.postRepository,
    required this.feedRepository,
    required this.errorHandler,
    required this.mediaService,
    required this.talker,
  }) : super(PostComposerState.initial()) {
    on<CreatePostRequested>(_onCreatePostRequested);
    on<EditPostRequested>(_onEditPostRequested);
    on<DeletePostRequested>(_onDeletePostRequested);
    on<PickImageFromCameraRequested>(_onPickImageFromCameraRequested);
    on<PickMediaFromGalleryRequested>(_onPickMediaFromGalleryRequested);
    on<RemoveMediaRequested>(_onRemoveMediaRequested);
    on<ClearMediaRequested>(_onClearMediaRequested);
    on<ToggleLike>(_onToggleLike);

    on<Subscribe>(_onSubscribe);
  }

  final PostRepository postRepository;
  final FeedRepository feedRepository;
  final ErrorHandler errorHandler;
  final MediaService mediaService;
  final Talker talker;

  Future<void> _onCreatePostRequested(
    CreatePostRequested event,
    Emitter<PostComposerState> emit,
  ) async {
    if (state.isCreating) return;
    try {
      emit(
        state.copyWith(
          isCreating: true,
          isCreateSuccess: false,
          createError: null,
          createdPost: null,
        ),
      );
      final response = await postRepository.createPost(
        CreatePostRequest(text: event.text, media: event.media),
      );
      emit(
        state.copyWith(
          isCreating: false,
          isCreateSuccess: true,
          createError: null,
          createdPost: response.post,
          media: null,
        ),
      );
    } catch (e, st) {
      emit(
        state.copyWith(
          isCreating: false,
          isCreateSuccess: false,
          createError: e.toString(),
        ),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onEditPostRequested(
    EditPostRequested event,
    Emitter<PostComposerState> emit,
  ) async {
    if (state.isUpdating) return;
    emit(
      state.copyWith(
        isUpdating: true,
        isUpdateSuccess: false,
        updateError: null,
        updatedPost: null,
      ),
    );
    try {
      final response = await postRepository.editPost(
        EditPostRequest(
          postId: event.postId,
          text: event.text,
          deletedMedia: event.deletedImages,
          media: event.media,
        ),
      );

      emit(
        state.copyWith(
          isUpdateSuccess: true,
          isUpdating: false,
          updateError: null,
          updatedPost: response.post,
          media: null,
        ),
      );
    } catch (e, st) {
      emit(
        state.copyWith(
          isUpdateSuccess: false,
          isUpdating: false,
          updateError: e.toString(),
        ),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onPickImageFromCameraRequested(
    PickImageFromCameraRequested event,
    Emitter<PostComposerState> emit,
  ) async {
    emit(state.copyWith(isMediaLoading: true));
    try {
      final image = await mediaService.takePhotoWithPermission();
      if (image == null) {
        emit(state.copyWith(isMediaLoading: false));
        return;
      }

      final currentMedia = state.media ?? [];
      final totalCount = currentMedia.length + 1;
      if (totalCount > 10) {
        errorHandler.handle("Можно выбрать максимум 10 файлов");
        emit(state.copyWith(isMediaLoading: false));
        return;
      }

      emit(
        state.copyWith(isMediaLoading: false, media: [image, ...currentMedia]),
      );
    } catch (e, st) {
      emit(state.copyWith(isMediaLoading: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onDeletePostRequested(
    DeletePostRequested event,
    Emitter<PostComposerState> emit,
  ) async {
    if (state.isDeleting) return;
    emit(
      state.copyWith(
        isDeleting: true,
        isDeleteSuccess: false,
        deleteError: null,
        deletedPostId: null,
      ),
    );
    try {
      final response = await postRepository.deletePost(
        DeletePostRequest(postId: event.postId),
      );

      if (!response.success) {
        throw ApiException(
          message: "Ошибка при удалении поста. Попробуйте еще раз",
        );
      }

      emit(
        state.copyWith(
          isDeleting: false,
          isDeleteSuccess: true,
          deleteError: null,
          deletedPostId: event.postId,
        ),
      );
    } catch (e, st) {
      emit(
        state.copyWith(
          isDeleting: false,
          isDeleteSuccess: false,
          deleteError: e.toString(),
        ),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onPickMediaFromGalleryRequested(
    PickMediaFromGalleryRequested event,
    Emitter<PostComposerState> emit,
  ) async {
    emit(state.copyWith(isMediaLoading: true));
    try {
      final media = await mediaService.pickMultipleMedia();
      if (media.isEmpty) {
        emit(state.copyWith(isMediaLoading: false));
        return;
      }

      final currentMedia = state.media ?? [];
      final totalCount = currentMedia.length + media.length;
      if (totalCount > 10) {
        errorHandler.handle("Можно выбрать максимум 10 файлов");
        emit(state.copyWith(isMediaLoading: false));
        return;
      }

      final filteredMedia = <File>[];
      for (final item in media) {
        final size = await item.length();
        if (_getFileSizeInMB(size) < 10) {
          filteredMedia.add(item);
        }
      }

      if (filteredMedia.length != media.length) {
        errorHandler.handle(
          "Не удалось прикрепить файл. Размер каждого файла должен быть не больше 10 МБ",
        );
        emit(state.copyWith(isMediaLoading: false));
        return;
      }

      emit(
        state.copyWith(
          isMediaLoading: false,
          media: [...filteredMedia, ...currentMedia],
        ),
      );
    } catch (e, st) {
      emit(state.copyWith(isMediaLoading: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onRemoveMediaRequested(
    RemoveMediaRequested event,
    Emitter<PostComposerState> emit,
  ) async {
    try {
      final currentMedia = state.media ?? [];
      final newMedia = List<File>.from(currentMedia)..removeAt(event.index);
      emit(state.copyWith(media: newMedia.isEmpty ? null : newMedia));
    } catch (e, st) {
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onClearMediaRequested(
    ClearMediaRequested event,
    Emitter<PostComposerState> emit,
  ) async {
    emit(state.copyWith(media: null));
  }

  double _getFileSizeInMB(int bytes, {int fractionDigits = 2}) {
    final mb = bytes / (1024 * 1024);
    return double.parse(mb.toStringAsFixed(fractionDigits));
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<PostComposerState> emit,
  ) async {
    final willLike = !event.post.likedByUser;
    final delta = willLike ? 1 : -1;
    final errorMessage = willLike
        ? "Не удалось поставить лайк"
        : "Не удалось убрать лайк";
    final originalPost = event.post;
    final optimisticPost = originalPost.copyWith(
      likesCount: originalPost.likesCount + delta,
      likedByUser: willLike,
    );

    emit(state.copyWith(likedPost: optimisticPost, likeError: null));

    try {
      final response = willLike
          ? await postRepository.likePost(
              LikePostRequest(postId: event.post.id),
            )
          : await postRepository.unlikePost(
              UnlikePostRequest(postId: event.post.id),
            );

      if (!response.success) {
        emit(state.copyWith(likedPost: originalPost, likeError: errorMessage));
        throw ApiException(message: errorMessage);
      }
    } catch (e, st) {
      emit(state.copyWith(likedPost: originalPost, likeError: errorMessage));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onSubscribe(
    Subscribe event,
    Emitter<PostComposerState> emit,
  ) async {
    emit(state.copyWith(subscribeError: null, subscribedUserId: null));
    try {
      final response = await feedRepository.subscribeToUser(
        SubscribeRequest(userId: event.userId),
      );
      if (!response.success) {
        const message = "Не удалось оформить подписку. Попробуйте снова";
        emit(state.copyWith(subscribeError: message, subscribedUserId: null));
        throw ApiException(message: message);
      }
      emit(
        state.copyWith(subscribeError: null, subscribedUserId: event.userId),
      );
    } catch (e, st) {
      emit(
        state.copyWith(
          subscribeError: "Не удалось оформить подписку. Попробуйте снова",
          subscribedUserId: null,
        ),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }
}
