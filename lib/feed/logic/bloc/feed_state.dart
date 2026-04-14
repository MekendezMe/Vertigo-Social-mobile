part of 'feed_bloc.dart';

const Object _notSet = Object();

abstract class FeedState extends Equatable {}

class FeedInitial extends FeedState {
  @override
  List<Object?> get props => [];
}

class FeedLoading extends FeedState {
  @override
  List<Object?> get props => [];
}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final User user;
  final bool isCreating;
  final String? createError;
  final String? likeError;
  final List<File>? media;
  final int currentPage;
  final bool isMediaLoading;
  final bool isLoadingMore;
  final bool isLastPage;
  final bool isCreateSuccess;
  final bool isUpdating;
  final bool isUpdateSuccess;
  final bool isDeleting;
  final bool isDeleteSuccess;
  final PostType currentType;
  final bool isSuccessSubscribed;

  FeedLoaded({
    required this.posts,
    required this.user,
    this.createError,
    this.isCreating = false,
    this.likeError,
    this.media,
    this.currentPage = 1,
    this.isMediaLoading = false,
    this.isLoadingMore = false,
    this.isLastPage = false,
    this.isCreateSuccess = false,
    this.isUpdating = false,
    this.isUpdateSuccess = false,
    this.isDeleting = false,
    this.isDeleteSuccess = false,
    this.isSuccessSubscribed = false,
    this.currentType = PostType.all,
  });
  @override
  List<Object?> get props => [
    posts,
    user,
    createError,
    isCreating,
    likeError,
    media,
    currentPage,
    isMediaLoading,
    isLoadingMore,
    isLastPage,
    isCreateSuccess,
    isUpdating,
    isUpdateSuccess,
    isDeleteSuccess,
    isDeleting,
    isSuccessSubscribed,
    currentType,
  ];

  FeedLoaded copyWith({
    List<Post>? posts,
    User? user,
    bool? isCreating,
    Object? createError = _notSet,
    Object? likeError = _notSet,
    Object? media = _notSet,
    int? currentPage,
    bool? isMediaLoading,
    bool? isLoadingMore,
    bool? isLastPage,
    bool? isCreateSuccess,
    bool? isUpdating,
    bool? isUpdateSuccess,
    bool? isDeleting,
    bool? isDeleteSuccess,
    PostType? currentType,
    bool? isSuccessSubscribed,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      user: user ?? this.user,
      isCreating: isCreating ?? this.isCreating,
      createError: identical(createError, _notSet)
          ? this.createError
          : createError as String?,
      likeError: identical(likeError, _notSet)
          ? this.likeError
          : likeError as String?,
      media: identical(media, _notSet) ? this.media : media as List<File>?,
      currentPage: currentPage ?? this.currentPage,
      isMediaLoading: isMediaLoading ?? false,
      isLoadingMore: isLoadingMore ?? false,
      isLastPage: isLastPage ?? this.isLastPage,
      isCreateSuccess: isCreateSuccess ?? false,
      isUpdating: isUpdating ?? false,
      isUpdateSuccess: isUpdateSuccess ?? false,
      isDeleting: isDeleting ?? false,
      isDeleteSuccess: isDeleteSuccess ?? false,
      isSuccessSubscribed: isSuccessSubscribed ?? false,
      currentType: currentType ?? this.currentType,
    );
  }
}

class FeedLoadingFailure extends FeedState {
  final Object? error;

  FeedLoadingFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
