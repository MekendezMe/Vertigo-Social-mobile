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
  final List<File>? images;
  final int currentPage;
  final bool isImageLoading;
  final bool isLoadingMore;
  final bool isLastPage;
  final bool isCreateSuccess;

  FeedLoaded({
    required this.posts,
    required this.user,
    this.createError,
    this.isCreating = false,
    this.likeError,
    this.images,
    this.currentPage = 1,
    this.isImageLoading = false,
    this.isLoadingMore = false,
    this.isLastPage = false,
    this.isCreateSuccess = false,
  });
  @override
  List<Object?> get props => [
    posts,
    user,
    createError,
    isCreating,
    likeError,
    images,
    currentPage,
    isImageLoading,
    isLoadingMore,
    isLastPage,
    isCreateSuccess,
  ];

  FeedLoaded copyWith({
    List<Post>? posts,
    User? user,
    bool? isCreating,
    Object? createError = _notSet,
    Object? likeError = _notSet,
    Object? images = _notSet,
    int? currentPage,
    bool? isImageLoading,
    bool? isLoadingMore,
    bool? isLastPage,
    bool? isCreateSuccess,
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
      images: identical(images, _notSet) ? this.images : images as List<File>?,
      currentPage: currentPage ?? this.currentPage,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLastPage: isLastPage ?? this.isLastPage,
      isCreateSuccess: isCreateSuccess ?? false,
    );
  }
}

class FeedLoadingFailure extends FeedState {
  final Object? error;

  FeedLoadingFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
