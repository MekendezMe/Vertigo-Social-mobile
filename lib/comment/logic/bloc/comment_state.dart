part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {}

class CommentInitial extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentsLoading extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentsLoaded extends CommentState {
  final Post post;
  final List<Comment> comments;
  final bool isLastPage;
  final int currentPage;

  CommentsLoaded({
    required this.comments,
    required this.isLastPage,
    required this.post,
    this.currentPage = 1,
  });
  @override
  List<Object?> get props => [comments, isLastPage, post, currentPage];

  CommentsLoaded copyWith({
    List<Comment>? comments,
    Post? post,
    bool? isLastPage,
    int? currentPage,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      isLastPage: isLastPage ?? this.isLastPage,
      post: post ?? this.post,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class CommentsLoadingFailure extends CommentState {
  final Object? error;

  CommentsLoadingFailure({this.error});

  @override
  List<Object?> get props => [error];
}
