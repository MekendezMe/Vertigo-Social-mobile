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
  final Comment? parent;
  final bool isLastPage;
  final int currentPage;
  final bool isLoadingMore;

  final List<Comment> answers;
  final bool answerIsLastPage;
  final int answerCurrentPage;
  final bool answersLoading;
  final bool answerIsLoadingMore;
  final String? answersError;

  CommentsLoaded({
    required this.comments,
    required this.isLastPage,
    required this.post,
    this.parent,
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.answers = const [],
    this.answerIsLastPage = false,
    this.answerCurrentPage = 1,
    this.answersLoading = false,
    this.answerIsLoadingMore = false,
    this.answersError,
  });
  @override
  List<Object?> get props => [
    comments,
    isLastPage,
    post,
    currentPage,
    isLoadingMore,
    answers,
    answerIsLastPage,
    answerCurrentPage,
    answerIsLoadingMore,
    parent,
    answersError,
    answersLoading,
  ];

  CommentsLoaded copyWith({
    List<Comment>? comments,
    Post? post,
    bool? isLastPage,
    int? currentPage,
    bool? isLoadingMore,
    List<Comment>? answers,
    bool? answerIsLastPage,
    int? answerCurrentPage,
    bool? answerIsLoadingMore,
    Comment? parent,
    String? answersError,
    bool? answersLoading,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      isLastPage: isLastPage ?? this.isLastPage,
      post: post ?? this.post,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      answers: answers ?? this.answers,
      answerIsLastPage: answerIsLastPage ?? this.answerIsLastPage,
      answerCurrentPage: answerCurrentPage ?? this.answerCurrentPage,
      answerIsLoadingMore: answerIsLoadingMore ?? this.answerIsLoadingMore,
      parent: parent ?? this.parent,
      answersError: answersError ?? this.answersError,
      answersLoading: answersLoading ?? this.answersLoading,
    );
  }
}

class CommentsLoadingFailure extends CommentState {
  final Object? error;

  CommentsLoadingFailure({this.error});

  @override
  List<Object?> get props => [error];
}
