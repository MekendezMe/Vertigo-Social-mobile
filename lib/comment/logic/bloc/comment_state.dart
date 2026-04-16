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

class CommentCreating extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentCreated extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentCreatingFailure extends CommentState {
  final Object? error;

  CommentCreatingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class AnswerCreating extends CommentState {
  @override
  List<Object?> get props => [];
}

class AnswerCreated extends CommentState {
  final bool isAnswerToRootComment;

  AnswerCreated({required this.isAnswerToRootComment});
  @override
  List<Object?> get props => [isAnswerToRootComment];
}

class AnswerCreatingFailure extends CommentState {
  final Object? error;

  AnswerCreatingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class AnswersLoading extends CommentState {
  @override
  List<Object?> get props => [];
}

class AnswersLoaded extends CommentState {
  @override
  List<Object?> get props => [];
}

class AnswersLoadingFailure extends CommentState {
  final Object? error;

  AnswersLoadingFailure({this.error});
  @override
  List<Object?> get props => [error];
}

class LikingFailure extends CommentState {
  final Object? error;

  LikingFailure({this.error});
  @override
  List<Object?> get props => [error];
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
  final bool answerIsLoadingMore;

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
    this.answerIsLoadingMore = false,
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
    );
  }
}

class CommentsLoadingFailure extends CommentState {
  final Object? error;

  CommentsLoadingFailure({this.error});

  @override
  List<Object?> get props => [error];
}
