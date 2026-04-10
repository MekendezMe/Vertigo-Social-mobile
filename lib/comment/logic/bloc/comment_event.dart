part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {}

class LoadComments extends CommentEvent {
  final int? pageNumber;
  final int postId;

  LoadComments({required this.postId, this.pageNumber});
  @override
  List<Object?> get props => [postId, pageNumber];
}

class LoadMoreComments extends CommentEvent {
  final int pageNumber;
  final int postId;

  LoadMoreComments({required this.pageNumber, required this.postId});
  @override
  List<Object?> get props => [pageNumber, postId];
}

class CreateComment extends CommentEvent {
  final int postId;
  final String content;

  CreateComment({required this.postId, required this.content});
  @override
  List<Object?> get props => [postId, content];
}

class LoadAnswers extends CommentEvent {
  final int? pageNumber;
  final int commentId;

  LoadAnswers({required this.commentId, this.pageNumber});
  @override
  List<Object?> get props => [commentId, pageNumber];
}

class LoadMoreAnswers extends CommentEvent {
  final int pageNumber;
  final int commentId;

  LoadMoreAnswers({required this.pageNumber, required this.commentId});
  @override
  List<Object?> get props => [pageNumber, commentId];
}

class CreateAnswer extends CommentEvent {
  final int postId;
  final String content;
  final int commentId;
  final int userId;
  final int? replyingCommentId;

  CreateAnswer({
    required this.postId,
    required this.content,
    required this.commentId,
    required this.userId,
    this.replyingCommentId,
  });
  @override
  List<Object?> get props => [
    postId,
    content,
    commentId,
    userId,
    replyingCommentId,
  ];
}

class ToggleLike extends CommentEvent {
  final int commentId;
  final bool isComment;

  ToggleLike({required this.commentId, required this.isComment});

  @override
  List<Object?> get props => [commentId, isComment];
}
