part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {}

class LoadFeed extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class CreatePost extends FeedEvent {
  final String text;

  CreatePost({required this.text});
  @override
  List<Object?> get props => [text];
}

class ToggleLike extends FeedEvent {
  final int postId;

  ToggleLike({required this.postId});
  @override
  List<Object?> get props => [postId];
}
