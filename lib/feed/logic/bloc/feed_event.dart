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

  LoadMorePosts({required this.pageNumber});
  @override
  List<Object?> get props => [pageNumber];
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
