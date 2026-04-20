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

class FeedLoadingFailure extends FeedState {
  final Object? error;

  FeedLoadingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final User user;
  final int currentPage;
  final bool isLoadingMore;
  final bool isLastPage;
  final PostType currentType;
  final bool isSuccessSubscribed;

  FeedLoaded({
    required this.posts,
    required this.user,
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.isLastPage = false,
    this.isSuccessSubscribed = false,
    this.currentType = PostType.all,
  });
  @override
  List<Object?> get props => [
    posts,
    user,
    currentPage,
    isLoadingMore,
    isLastPage,
    isSuccessSubscribed,
    currentType,
  ];

  FeedLoaded copyWith({
    List<Post>? posts,
    User? user,
    Object? likeError = _notSet,
    int? currentPage,
    bool? isLoadingMore,
    bool? isLastPage,
    PostType? currentType,
    bool? isSuccessSubscribed,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      user: user ?? this.user,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? false,
      isLastPage: isLastPage ?? this.isLastPage,
      isSuccessSubscribed: isSuccessSubscribed ?? false,
      currentType: currentType ?? this.currentType,
    );
  }
}
