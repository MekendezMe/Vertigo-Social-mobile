part of 'post_composer_bloc.dart';

abstract class PostComposerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePostRequested extends PostComposerEvent {
  CreatePostRequested({required this.text, required this.media});

  final String text;
  final List<File> media;

  @override
  List<Object?> get props => [text, media];
}

class EditPostRequested extends PostComposerEvent {
  EditPostRequested({
    required this.postId,
    required this.text,
    required this.media,
    required this.deletedImages,
  });

  final int postId;
  final String text;
  final List<File> media;
  final List<String> deletedImages;

  @override
  List<Object?> get props => [postId, text, media, deletedImages];
}

class DeletePostRequested extends PostComposerEvent {
  DeletePostRequested({required this.postId});

  final int postId;

  @override
  List<Object?> get props => [postId];
}

class PickImageFromCameraRequested extends PostComposerEvent {}

class PickMediaFromGalleryRequested extends PostComposerEvent {}

class RemoveMediaRequested extends PostComposerEvent {
  RemoveMediaRequested({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

class ClearMediaRequested extends PostComposerEvent {}

class ToggleLike extends PostComposerEvent {
  final Post post;
  final int postId;

  ToggleLike({required this.post})
    : postId = post.id;
  @override
  List<Object?> get props => [postId, post];
}

class Subscribe extends PostComposerEvent {
  final int userId;

  Subscribe({required this.userId});
  @override
  List<Object?> get props => [userId];
}
