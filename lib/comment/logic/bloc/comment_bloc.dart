import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/feed/logic/entites/comment.dart';
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
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) {
      emit(CommentsLoading());
    }
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
}
