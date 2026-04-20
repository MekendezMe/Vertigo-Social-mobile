import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/common/authentication/user/service/user_service.dart';
import 'package:social_network_flutter/common/framework/errors/error_handler.dart';
import 'package:social_network_flutter/common/framework/errors/exceptions/app_exceptions.dart';
import 'package:social_network_flutter/feed/logic/entites/user.dart';
import 'package:social_network_flutter/post/logic/entities/post.dart';
import 'package:social_network_flutter/post/logic/entities/request/get_post_request.dart';
import 'package:social_network_flutter/post/logic/repository/post_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  final ErrorHandler errorHandler;
  final Talker talker;
  final UserService userService;
  PostBloc({
    required this.postRepository,
    required this.errorHandler,
    required this.talker,
    required this.userService,
  }) : super(PostInitial()) {
    on<LoadPost>(_onLoadPost);
    on<PostPatchedLocally>(_onPostPatchedLocally);
  }

  Future<void> _onLoadPost(LoadPost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final response = await postRepository.getPost(
        GetPostRequest(postId: event.postId),
      );
      final currentUser = userService.currentUser;
      if (currentUser == null) {
        throw AuthException();
      }
      emit(PostLoaded(post: response.post, user: currentUser));
    } catch (e, st) {
      emit(PostLoadingFailure(error: e));
      talker.handle(e, st);
      errorHandler.handle(e);
    }
  }

  Future<void> _onPostPatchedLocally(
    PostPatchedLocally event,
    Emitter<PostState> emit,
  ) async {
    if (state is! PostLoaded) return;
    final current = state as PostLoaded;
    emit(PostLoaded(post: event.post, user: current.user));
  }
}
