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

class CreatePost extends FeedEvent {
  final String text;
  final List<File> media;

  CreatePost({required this.text, required this.media});
  @override
  List<Object?> get props => [text, media];
}

class EditPost extends FeedEvent {
  final int postId;
  final String text;
  final List<File> media;
  final List<String> deletedImages;

  EditPost({
    required this.postId,
    required this.text,
    required this.media,
    required this.deletedImages,
  });

  @override
  List<Object?> get props => [postId, text, media, deletedImages];
}

class DeletePost extends FeedEvent {
  final int postId;

  DeletePost({required this.postId});
  @override
  List<Object?> get props => [postId];
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

class PickMediaFromGallery extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class RemoveMediaFromPost extends FeedEvent {
  final int index;

  RemoveMediaFromPost({required this.index});

  @override
  List<Object?> get props => [index];
}

class ClearMedia extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class Subscribe extends FeedEvent {
  final int userId;

  Subscribe({required this.userId});
  @override
  List<Object?> get props => [];
}

class ClearCreateStatus extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class ClearSubscribeStatus extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class ClearDeleteStatus extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class ClearUpdateStatus extends FeedEvent {
  @override
  List<Object?> get props => [];
}
