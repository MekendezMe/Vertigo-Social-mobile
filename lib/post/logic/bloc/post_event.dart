part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {}

class LoadPost extends PostEvent {
  final int postId;

  LoadPost({required this.postId});
  @override
  List<Object?> get props => [postId];
}

class PostPatchedLocally extends PostEvent {
  final Post post;

  PostPatchedLocally({required this.post});

  @override
  List<Object?> get props => [post];
}
