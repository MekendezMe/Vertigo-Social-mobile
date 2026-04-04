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
  final bool? isLoadingMore;

  CommentsLoaded({
    required this.comments,
    required this.isLastPage,
    required this.post,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });
  @override
  List<Object?> get props => [
    comments,
    isLastPage,
    post,
    currentPage,
    isLoadingMore,
  ];

  CommentsLoaded copyWith({
    List<Comment>? comments,
    Post? post,
    bool? isLastPage,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      isLastPage: isLastPage ?? this.isLastPage,
      post: post ?? this.post,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CommentsLoadingFailure extends CommentState {
  final Object? error;

  CommentsLoadingFailure({this.error});

  @override
  List<Object?> get props => [error];
}
