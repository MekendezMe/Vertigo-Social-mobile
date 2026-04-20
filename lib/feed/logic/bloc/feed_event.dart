part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {}

class LoadFeed extends FeedEvent {
  final int? pageNumber;

  LoadFeed({this.pageNumber});
  @override
  List<Object?> get props => [pageNumber];
}

class LoadMorePosts extends FeedEvent {
  final int pageNumber;
  final PostType type;

  LoadMorePosts({required this.pageNumber, required this.type});
  @override
  List<Object?> get props => [pageNumber, type];
}

class ChangeFeedType extends FeedEvent {
  final PostType type;

  ChangeFeedType({required this.type});
  @override
  List<Object?> get props => [type];
}

class AddPostToTop extends FeedEvent {
  AddPostToTop({required this.post});

  final Post post;

  @override
  List<Object?> get props => [post];
}

class ReplacePostInFeed extends FeedEvent {
  ReplacePostInFeed({required this.post});

  final Post post;

  @override
  List<Object?> get props => [post];
}

class RemovePostFromFeed extends FeedEvent {
  RemovePostFromFeed({required this.postId});

  final int postId;

  @override
  List<Object?> get props => [postId];
}

class MarkUserSubscribedInFeed extends FeedEvent {
  MarkUserSubscribedInFeed({required this.userId});

  final int userId;

  @override
  List<Object?> get props => [userId];
}
