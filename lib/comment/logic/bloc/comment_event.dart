part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {}

class LoadComments extends CommentEvent {
  final int? pageNumber;
  final int postId;

  LoadComments({required this.postId, this.pageNumber});
  @override
  List<Object?> get props => [postId];
}
