import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/request/create_answers_request.dart';
import 'package:social_network_flutter/comment/logic/entities/request/create_comments_request.dart';
import 'package:social_network_flutter/comment/logic/entities/request/get_answers_request.dart';
import 'package:social_network_flutter/comment/logic/entities/request/like_comment_request.dart';
import 'package:social_network_flutter/comment/logic/entities/request/unlike_comment_request.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/comment/logic/entities/request/get_comments_request.dart';
import 'package:social_network_flutter/comment/logic/repository/comment_repository.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/feed/logic/entites/post.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;
  final Talker talker;
  final ErrorHandler errorHandler;
  final UserService userService;
  CommentBloc({
    required this.commentRepository,
    required this.talker,
    required this.errorHandler,
    required this.userService,
  }) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<LoadMoreComments>(_onLoadMoreComments);
    on<CreateComment>(_onCreateComment);

    on<LoadAnswers>(_onLoadAnswers);
    on<LoadMoreAnswers>(_onLoadMoreAnswers);
    on<CreateAnswer>(_onCreateAnswer);

    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentsLoading());
    try {
      final response = await commentRepository.getCommentsByPost(
        GetCommentsRequest(
          postId: event.postId,
          pageNumber: event.pageNumber ?? 1,
        ),
      );

      emit(
        CommentsLoaded(
          post: response.post,
          comments: response.comments,
          isLastPage: response.lastPage,
        ),
      );
    } catch (e, st) {
      emit(CommentsLoadingFailure(error: e));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onLoadMoreComments(
    LoadMoreComments event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) {
      return;
    }
    final current = state as CommentsLoaded;
    try {
      emit(current.copyWith(isLoadingMore: true));
      final response = await commentRepository.getCommentsByPost(
        GetCommentsRequest(postId: event.postId, pageNumber: event.pageNumber),
      );

      emit(
        current.copyWith(
          comments: [...current.comments, ...response.comments],
          isLastPage: response.comments.isEmpty ? true : response.lastPage,
          isLoadingMore: false,
          currentPage: event.pageNumber,
        ),
      );
    } catch (e, st) {
      emit(CommentsLoadingFailure(error: e));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onCreateComment(
    CreateComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) {
      return;
    }
    final current = state as CommentsLoaded;
    if (current.isCreate) return;
    emit(current.copyWith(isCreate: true, isCreateSuccess: false));

    try {
      final response = await commentRepository.createComment(
        CreateCommentsRequest(postId: event.postId, content: event.content),
      );
      emit(
        current.copyWith(
          comments: [...current.comments, response.comment],
          isCreate: false,
          createError: null,
          isCreateSuccess: true,
        ),
      );
    } catch (e, st) {
      emit(
        current.copyWith(
          createError: e.toString(),
          isCreate: false,
          isCreateSuccess: false,
        ),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onLoadAnswers(
    LoadAnswers event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) {
      return;
    }
    final current = state as CommentsLoaded;
    emit(current.copyWith(answersLoading: true));
    try {
      final response = await commentRepository.getAnswersByComment(
        GetAnswersRequest(
          commentId: event.commentId,
          pageNumber: event.pageNumber ?? 1,
        ),
      );
      emit(
        current.copyWith(
          parent: response.parent,
          answers: response.answers,
          answerIsLastPage: response.lastPage,
          answersError: null,
          answersLoading: false,
        ),
      );
    } catch (e, st) {
      emit(current.copyWith(answersError: e.toString(), answersLoading: false));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onLoadMoreAnswers(
    LoadMoreAnswers event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) {
      return;
    }
    final current = state as CommentsLoaded;
    try {
      emit(current.copyWith(answerIsLoadingMore: true));
      final response = await commentRepository.getAnswersByComment(
        GetAnswersRequest(
          commentId: event.commentId,
          pageNumber: event.pageNumber,
        ),
      );

      emit(
        current.copyWith(
          parent: response.parent,
          answers: [...current.answers, ...response.answers],
          answerIsLastPage: response.answers.isEmpty ? true : response.lastPage,
          answerIsLoadingMore: false,
          answerCurrentPage: event.pageNumber,
          answersError: null,
        ),
      );
    } catch (e, st) {
      emit(current.copyWith(answersError: e.toString()));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onCreateAnswer(
    CreateAnswer event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) {
      return;
    }
    final current = state as CommentsLoaded;
    if (current.isAnswersCreate) return;
    emit(
      current.copyWith(isAnswersCreate: true, isCreateAnswersSuccess: false),
    );
    try {
      final response = await commentRepository.createAnswer(
        CreateAnswersRequest(
          commentId: event.commentId,
          content: event.content,
          userId: event.userId,
          postId: event.postId,
        ),
      );
      final answers = List<Comment>.from(current.answers);
      final comments = List<Comment>.from(current.comments);
      final index = answers.indexWhere(
        (c) => c.id == (event.replyingCommentId ?? 0),
      );

      bool isAnswerToRootComment = false;

      if (index != -1) {
        answers.insert(index + 1, response.answer);
        answers[index] = answers[index].copyWith(
          answersCount: (answers[index].answersCount + 1),
        );
      } else {
        answers.add(response.answer);
        isAnswerToRootComment = true;
      }

      final commentIndex = comments.indexWhere((c) => c.id == event.commentId);
      final comment = comments[commentIndex];

      comments[commentIndex] = comment.copyWith(
        answersCount: (comment.answersCount) + 1,
      );

      emit(
        current.copyWith(
          comments: comments,
          answers: answers,
          isAnswersCreate: false,
          isCreateAnswersSuccess: true,
          isAnswerToRootComment: isAnswerToRootComment,
        ),
      );
    } catch (e, st) {
      emit(
        current.copyWith(isAnswersCreate: false, isCreateAnswersSuccess: false),
      );
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) return;
    final currentState = state as CommentsLoaded;

    final isComments = event.isComment;
    final comments = event.isComment
        ? currentState.comments
        : currentState.answers;

    final targetComment = comments.firstWhere(
      (comment) => comment.id == event.commentId,
    );
    final willLike = !targetComment.likedByUser;
    final delta = willLike ? 1 : -1;
    final errorMessage = willLike
        ? "Не удалось поставить лайк"
        : "Не удалось убрать лайк";
    final originalComment = targetComment;

    final optimisticComments = comments.map((comment) {
      if (comment.id == event.commentId) {
        return comment.copyWith(
          likesCount: comment.likesCount + delta,
          likedByUser: willLike,
        );
      }
      return comment;
    }).toList();

    if (isComments) {
      emit(
        currentState.copyWith(comments: optimisticComments, likeError: null),
      );
    } else {
      emit(currentState.copyWith(answers: optimisticComments, likeError: null));
    }
    try {
      final response = willLike
          ? await commentRepository.likeComment(
              LikeCommentRequest(commentId: event.commentId),
            )
          : await commentRepository.unlikeComment(
              UnlikeCommentRequest(commentId: event.commentId),
            );

      if (!response.success) {
        final rolledBackComments = _getRolledBackComments(
          commentId: event.commentId,
          originalComment: originalComment,
          currentState: currentState,
        );
        if (isComments) {
          emit(
            currentState.copyWith(
              comments: rolledBackComments,
              likeError: errorMessage,
            ),
          );
        } else {
          emit(
            currentState.copyWith(
              answers: rolledBackComments,
              likeError: errorMessage,
            ),
          );
        }

        throw ApiException(message: errorMessage);
      }
    } catch (e, st) {
      final rolledBackComments = _getRolledBackComments(
        commentId: event.commentId,
        originalComment: originalComment,
        currentState: currentState,
      );
      if (isComments) {
        emit(
          currentState.copyWith(
            comments: rolledBackComments,
            likeError: errorMessage,
          ),
        );
      } else {
        emit(
          currentState.copyWith(
            answers: rolledBackComments,
            likeError: errorMessage,
          ),
        );
      }
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  List<Comment> _getRolledBackComments({
    required int commentId,
    required Comment originalComment,
    required CommentsLoaded currentState,
  }) {
    return currentState.comments.map((comment) {
      if (comment.id == commentId) {
        return originalComment;
      }
      return comment;
    }).toList();
  }
}
