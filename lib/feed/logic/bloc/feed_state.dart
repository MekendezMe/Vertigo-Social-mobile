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

  FeedLoaded({
    required this.posts,
    required this.user,
    this.createError,
    this.isCreating = false,
    this.likeError,
  });
  @override
  List<Object?> get props => [posts, user, createError, isCreating, likeError];

  FeedLoaded copyWith({
    List<Post>? posts,
    User? user,
    bool? isCreating = false,
    String? createError,
    bool? isLiking = false,
    String? likeError,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      user: user ?? this.user,
      isCreating: isCreating ?? this.isCreating,
      createError: createError ?? this.createError,
      likeError: likeError ?? this.likeError,
    );
  }
}

class FeedLoadingFailure extends FeedState {
  final Object? error;

  FeedLoadingFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
