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

class PostCreating extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostCreated extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostCreatingFailure extends FeedState {
  final Object? error;

  PostCreatingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class PostUpdating extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostUpdated extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostUpdatingFailure extends FeedState {
  final Object? error;

  PostUpdatingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class PostDeleting extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostDeleted extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostDeletingFailure extends FeedState {
  final Object? error;

  PostDeletingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class UserSubscribed extends FeedState {
  @override
  List<Object?> get props => [];
}

class UserSubscribingFailure extends FeedState {
  final Object? error;

  UserSubscribingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class PostLiking extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostLiked extends FeedState {
  @override
  List<Object?> get props => [];
}

class PostLikingFailure extends FeedState {
  final Object? error;

  PostLikingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class MediaLoading extends FeedState {
  @override
  List<Object?> get props => [];
}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final User user;
  final List<File>? media;
  final int currentPage;
  final bool isLoadingMore;
  final bool isLastPage;
  final PostType currentType;

  FeedLoaded({
    required this.posts,
    required this.user,
    this.media,
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.isLastPage = false,
    this.currentType = PostType.all,
  });
  @override
  List<Object?> get props => [
    posts,
    user,
    media,
    currentPage,
    isLoadingMore,
    isLastPage,
    currentType,
  ];

  FeedLoaded copyWith({
    List<Post>? posts,
    User? user,
    Object? media = _notSet,
    int? currentPage,
    bool? isLoadingMore,
    bool? isLastPage,
    PostType? currentType,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      user: user ?? this.user,
      media: identical(media, _notSet) ? this.media : media as List<File>?,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? false,
      isLastPage: isLastPage ?? this.isLastPage,
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
