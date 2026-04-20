part of 'post_composer_bloc.dart';

const Object _notSet = Object();

class PostComposerState extends Equatable {
  const PostComposerState({
    required this.isCreating,
    required this.isUpdating,
    required this.isDeleting,
    required this.isMediaLoading,
    required this.isCreateSuccess,
    required this.isUpdateSuccess,
    required this.isDeleteSuccess,
    this.createError,
    this.updateError,
    this.deleteError,
    this.createdPost,
    this.updatedPost,
    this.deletedPostId,
    this.media,
    this.likeError,
    this.likedPost,
    this.subscribeError,
    this.subscribedUserId,
  });

  factory PostComposerState.initial() => const PostComposerState(
    isCreating: false,
    isUpdating: false,
    isDeleting: false,
    isMediaLoading: false,
    isCreateSuccess: false,
    isUpdateSuccess: false,
    isDeleteSuccess: false,
    createError: null,
    updateError: null,
    deleteError: null,
    createdPost: null,
    updatedPost: null,
    deletedPostId: null,
    media: null,
    likeError: null,
    likedPost: null,
    subscribeError: null,
    subscribedUserId: null,
  );

  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final bool isMediaLoading;
  final bool isCreateSuccess;
  final bool isUpdateSuccess;
  final bool isDeleteSuccess;
  final String? createError;
  final String? updateError;
  final String? deleteError;
  final Post? createdPost;
  final Post? updatedPost;
  final int? deletedPostId;
  final List<File>? media;
  final String? likeError;
  final Post? likedPost;
  final String? subscribeError;
  final int? subscribedUserId;

  PostComposerState copyWith({
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    bool? isMediaLoading,
    bool? isCreateSuccess,
    bool? isUpdateSuccess,
    bool? isDeleteSuccess,
    Object? createError = _notSet,
    Object? updateError = _notSet,
    Object? deleteError = _notSet,
    Object? createdPost = _notSet,
    Object? updatedPost = _notSet,
    Object? deletedPostId = _notSet,
    Object? media = _notSet,
    Object? likeError = _notSet,
    Object? likedPost = _notSet,
    Object? subscribeError = _notSet,
    Object? subscribedUserId = _notSet,
  }) {
    return PostComposerState(
      isCreating: isCreating ?? false,
      isUpdating: isUpdating ?? false,
      isDeleting: isDeleting ?? false,
      isMediaLoading: isMediaLoading ?? false,
      isCreateSuccess: isCreateSuccess ?? false,
      isUpdateSuccess: isUpdateSuccess ?? false,
      isDeleteSuccess: isDeleteSuccess ?? false,
      createError: identical(createError, _notSet)
          ? this.createError
          : createError as String?,
      updateError: identical(updateError, _notSet)
          ? this.updateError
          : updateError as String?,
      deleteError: identical(deleteError, _notSet)
          ? this.deleteError
          : deleteError as String?,
      likeError: identical(likeError, _notSet)
          ? this.likeError
          : likeError as String?,
      likedPost: identical(likedPost, _notSet)
          ? this.likedPost
          : likedPost as Post?,
      subscribeError: identical(subscribeError, _notSet)
          ? this.subscribeError
          : subscribeError as String?,
      subscribedUserId: identical(subscribedUserId, _notSet)
          ? this.subscribedUserId
          : subscribedUserId as int?,
      createdPost: identical(createdPost, _notSet)
          ? this.createdPost
          : createdPost as Post?,
      updatedPost: identical(updatedPost, _notSet)
          ? this.updatedPost
          : updatedPost as Post?,
      deletedPostId: identical(deletedPostId, _notSet)
          ? this.deletedPostId
          : deletedPostId as int?,
      media: identical(media, _notSet) ? this.media : media as List<File>?,
    );
  }

  @override
  List<Object?> get props => [
    isCreating,
    isUpdating,
    isDeleting,
    isMediaLoading,
    isCreateSuccess,
    isUpdateSuccess,
    isDeleteSuccess,
    createError,
    updateError,
    deleteError,
    createdPost,
    updatedPost,
    deletedPostId,
    media,
    likeError,
    likedPost,
    subscribeError,
    subscribedUserId,
  ];
}
