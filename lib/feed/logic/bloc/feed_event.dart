part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {}

class LoadFeed extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class CreatePost extends FeedEvent {
  final String text;
  final int userId;

  CreatePost({required this.text, required this.userId});
  @override
  List<Object?> get props => [text, userId];
}

class LikePost extends FeedEvent {
  final int postId;
  final int userId;

  LikePost({required this.postId, required this.userId});
  @override
  List<Object?> get props => [postId, userId];
}

class UnlikePost extends FeedEvent {
  final int postId;
  final int userId;
  UnlikePost({required this.postId, required this.userId});
  @override
  List<Object?> get props => [postId, userId];
}
