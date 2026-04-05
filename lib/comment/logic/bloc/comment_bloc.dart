import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/request/get_answers_request.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/comment/logic/entities/request/get_comments_request.dart';
import 'package:social_network_flutter/comment/logic/repository/comment_repository.dart';
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

    on<LoadAnswers>(_onLoadAnswers);
    on<LoadMoreAnswers>(_onLoadMoreAnswers);
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
          isLastPage: response.lastPage,
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
          answerIsLastPage: response.lastPage,
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
}
