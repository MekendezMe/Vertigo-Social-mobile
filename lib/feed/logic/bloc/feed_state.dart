part of 'feed_bloc.dart';

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
  final bool? isImageLoading;
  final bool? isLoadingMore;
  final bool? isLastPage;

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
  ];

  FeedLoaded copyWith({
    List<Post>? posts,
    User? user,
    bool? isCreating,
    String? createError,
    String? likeError,
    List<File>? images,
    int? currentPage,
    bool? isImageLoading,
    bool? isLoadingMore,
    bool? isLastPage,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      user: user ?? this.user,
      isCreating: isCreating ?? this.isCreating,
      createError: createError ?? this.createError,
      likeError: likeError ?? this.likeError,
      images: images ?? this.images,
      currentPage: currentPage ?? this.currentPage,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

class FeedLoadingFailure extends FeedState {
  final Object? error;

  FeedLoadingFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
