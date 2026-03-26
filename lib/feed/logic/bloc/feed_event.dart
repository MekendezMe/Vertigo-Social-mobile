part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {}

class LoadFeed extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class CreatePost extends FeedEvent {
  final String text;
  final List<File> images;

  CreatePost({required this.text, required this.images});
  @override
  List<Object?> get props => [text, images];
}

class ToggleLike extends FeedEvent {
  final int postId;

  ToggleLike({required this.postId});
  @override
  List<Object?> get props => [postId];
}

class PickImageFromCamera extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class PickImagesFromGallery extends FeedEvent {
  @override
  List<Object?> get props => [];
}
