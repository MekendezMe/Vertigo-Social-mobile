import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/comment/logic/helpers/navigation_type_helper.dart';
import 'package:social_network_flutter/comment/ui/widgets/drag_handle_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/header_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/comment_create_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/comment_scroll_view_widget.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast_widget.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/loading/build_loading_failure.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.commentBloc,
    required this.postId,
    this.fromModal = true,
  });
  final CommentBloc commentBloc;
  final int postId;
  final bool fromModal;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final List<NavigationItem> _navigationStack = [];
  final Map<String, ScrollController> _scrollControllers = {};
  ScrollController? _currentScrollController;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isAnswer = false;
  Comment? _replyingComment;
  Comment? _rootComment;

  @override
  void dispose() {
    _currentScrollController?.removeListener(_onScroll);
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  ScrollController _getScrollController(int parentId, NavigationType type) {
    String key = type.name;
    // if (type == NavigationType.comments) {
    //   key += "_$parentId";
    // }
    if (!_scrollControllers.containsKey(key)) {
      _scrollControllers[key] = ScrollController();
    }
    return _scrollControllers[key]!;
  }

  int getCurrentId(NavigationItem item) {
    if (item.type == NavigationType.comments) {
      return item.postId!;
    } else {
      return item.commentId!;
    }
  }

  void updateController() {
    if (_currentScrollController != null) {
      _currentScrollController?.removeListener(_onScroll);
    }
    final current = _navigationStack.last;
    _currentScrollController = _getScrollController(
      getCurrentId(current),
      current.type,
    );
    _currentScrollController?.addListener(_onScroll);
  }

  @override
  void initState() {
    super.initState();
    _navigationStack.add(NavigationItem.comments(postId: widget.postId));
    updateController();
    _loadComments();
  }

  void _loadComments() {
    final current = _navigationStack.last;
    if (current.type == NavigationType.comments) {
      clearRootComment();
      widget.commentBloc.add(LoadComments(postId: current.postId!));
    } else {
      widget.commentBloc.add(LoadAnswers(commentId: current.commentId!));
    }
  }

  void clearRootComment() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _rootComment = null;
        });
      }
    });
  }

  void _navigateToAnswers(Comment comment) {
    setState(() {
      _navigationStack.add(NavigationItem.answers(commentId: comment.id));
      updateController();
      _replyingComment = comment;
      _rootComment = comment;
    });

    _loadComments();
  }

  void _navigateBack() {
    if (_navigationStack.length > 1) {
      setState(() {
        _navigationStack.removeLast();
        updateController();
        clearRootComment();
      });
    }
  }

  bool get _canGoBack => _navigationStack.length > 1;

  Widget _buildLoading(BuildContext context) {
    return Center(child: customCircularProgressIndicator(context: context));
  }

  @override
  Widget build(BuildContext context) {
    final current = _navigationStack.last;
    final double height = widget.fromModal
        ? MediaQuery.of(context).size.height * 0.9
        : MediaQuery.of(context).size.height * 0.6;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.color.veryLightGray,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          if (widget.fromModal) DragHandleWidget(),
          HeaderWidget(
            current: current,
            canGoBack: _canGoBack,
            onNavigateBack: _navigateBack,
            showClose: widget.fromModal,
          ),
          Divider(color: context.color.darkGray, height: 1, thickness: 0.5),
          Expanded(
            child: BlocConsumer<CommentBloc, CommentState>(
              bloc: widget.commentBloc,
              listener: (context, state) {
                if (state is CommentsLoaded) {
                  if (state.isCreateSuccess) {
                    CustomToast.show(
                      CustomToastWidget(text: "Комментарий создан"),
                      dismissAfter: const Duration(milliseconds: 1500),
                    );
                    onCreate();
                    _animateScroll(toStart: false);
                  }

                  if (current.type == NavigationType.comments &&
                      state.isCreateAnswersSuccess &&
                      _rootComment != null) {
                    _navigateToAnswers(_replyingComment ?? _rootComment!);
                    onCreate();
                    _animateScroll(toStart: false);
                  }

                  if (current.type == NavigationType.answers &&
                      state.isCreateAnswersSuccess) {
                    CustomToast.show(
                      CustomToastWidget(text: "Ответ создан"),
                      dismissAfter: const Duration(milliseconds: 1500),
                    );
                    onCreate();
                    if (state.isAnswerToRootComment) {
                      _animateScroll(toStart: false);
                    }
                  }
                }
              },
              builder: (context, state) {
                if (state is CommentsLoading) {
                  return _buildLoading(context);
                }
                if (state is CommentsLoadingFailure) {
                  return buildLoadingFailure(
                    context: context,
                    error: state.error.toString(),
                    onTap: () => _loadComments(),
                  );
                }

                if (state is CommentsLoaded) {
                  bool isAnswersError =
                      current.type == NavigationType.answers &&
                      state.answersError != null;
                  final isComments = current.type == NavigationType.comments;
                  final scrollController = _getScrollController(
                    getCurrentId(current),
                    current.type,
                  );
                  final isEmpty = isComments
                      ? state.comments.isEmpty
                      : state.answers.isEmpty;
                  if (state.answersLoading) {
                    return _buildLoading(context);
                  }
                  if (isAnswersError) {
                    return buildLoadingFailure(
                      error: state.answersError,
                      context: context,
                      onTap: () => _loadComments(),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              Icon(
                                isComments
                                    ? Icons.chat_bubble_outline
                                    : Icons.reply_outlined,
                                size: 48,
                                color: context.color.gray,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                isComments ? 'Нет комментариев' : 'Нет ответов',
                                style: context.theme.textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        )
                      else
                        Expanded(
                          child: RefreshIndicator(
                            backgroundColor: context.color.darkGray,
                            color: context.color.lightPurple,
                            onRefresh: () async {
                              final completer = Completer<void>();
                              _commentController.text = "";

                              final subscription = widget.commentBloc.stream
                                  .listen((state) {
                                    if (state is CommentsLoaded ||
                                        state is CommentsLoadingFailure) {
                                      completer.complete();
                                    }
                                  });

                              _loadComments();

                              await completer.future;

                              await subscription.cancel();
                            },
                            child: CommentScrollViewWidget(
                              state: state,
                              current: _navigationStack.last,
                              controller: scrollController,
                              onReplyPressed: ({required Comment comment}) =>
                                  _navigateToAnswers(comment),
                              onAnswerPressed: ({required Comment comment}) =>
                                  onAnswerPressed(comment),
                              onLikePressed: ({required Comment comment}) =>
                                  onLikePressed(comment),
                            ),
                          ),
                        ),
                      SizedBox(height: 10),
                      CommentCreateWidget(
                        state: state,
                        commentBloc: widget.commentBloc,
                        replyingComment: _replyingComment,
                        current: current,
                        onCloseAnswerPressed: onCloseAnswerPressed,
                        controller: _commentController,
                        commentFocusNode: _commentFocusNode,
                        isAnswer: _isAnswer,
                        rootComment: _rootComment,
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void onCreate() {
    clearAll();
  }

  void clearAll() {
    setState(() {
      _isAnswer = false;
      _replyingComment = null;
      _commentController.text = "";
    });
    _commentFocusNode.unfocus();
  }

  void onCloseAnswerPressed() {
    clearAll();
  }

  void onLikePressed(Comment comment) {
    final isComment = _navigationStack.last.type == NavigationType.comments;
    widget.commentBloc.add(
      ToggleLike(commentId: comment.id, isComment: isComment),
    );
  }

  void _animateScroll({bool toStart = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentScrollController != null &&
          _currentScrollController!.hasClients) {
        _currentScrollController!.animateTo(
          toStart ? 0 : _currentScrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onAnswerPressed(Comment comment) {
    final current = _navigationStack.last;
    if (current.type == NavigationType.comments) {
      setState(() {
        _rootComment = comment;
        _isAnswer = true;
      });
    } else {
      setState(() {
        _replyingComment = comment;
        _isAnswer = true;
      });
    }

    _commentController.text = "@${comment.author.username} ";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentFocusNode.requestFocus();
    });
  }

  void _onScroll() {
    final currentStack = _navigationStack.last;
    bool isComments = currentStack.type == NavigationType.comments;
    final id = getCurrentId(currentStack);
    final scrollController = _getScrollController(id, currentStack.type);

    if (!scrollController.hasClients) return;

    final blocState = context.read<CommentBloc>().state;

    if (blocState is! CommentsLoaded) return;

    final isLoadingMore = currentStack.type == NavigationType.comments
        ? blocState.isLoadingMore
        : blocState.answerIsLoadingMore;

    final isLastPage = currentStack.type == NavigationType.comments
        ? blocState.isLastPage
        : blocState.answerIsLastPage;

    if (isLoadingMore || isLastPage) return;

    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;

    if (current >= max - 200) {
      if (isComments) {
        final nextPage = blocState.currentPage + 1;
        context.read<CommentBloc>().add(
          LoadMoreComments(pageNumber: nextPage, postId: blocState.post.id),
        );
      } else {
        final nextPage = blocState.answerCurrentPage + 1;
        context.read<CommentBloc>().add(
          LoadMoreAnswers(
            pageNumber: nextPage,
            commentId: blocState.parent!.id,
          ),
        );
      }
    }
  }
}
