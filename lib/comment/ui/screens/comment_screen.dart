import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/comment/logic/helpers/navigation_type_helper.dart';
import 'package:social_network_flutter/comment/ui/widgets/build_drag_handle_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/build_header_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/comment_scroll_view_widget.dart';
import 'package:social_network_flutter/comment/ui/widgets/empty_comment_widget.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.commentBloc,
    required this.postId,
  });
  final CommentBloc commentBloc;
  final int postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final List<NavigationItem> _navigationStack = [];
  final Map<String, ScrollController> _scrollControllers = {};
  ScrollController? _currentScrollController;
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentError = false;

  @override
  void dispose() {
    _currentScrollController?.removeListener(_onScroll);
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
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
      widget.commentBloc.add(LoadComments(postId: current.postId!));
    } else {
      widget.commentBloc.add(LoadAnswers(commentId: current.commentId!));
    }
  }

  void _navigateToAnswers(Comment comment) {
    setState(() {
      _navigationStack.add(NavigationItem.answers(commentId: comment.id));
      updateController();
    });

    _loadComments();
  }

  void _navigateBack() {
    if (_navigationStack.length > 1) {
      setState(() {
        _navigationStack.removeLast();
        updateController();
      });
    }
  }

  bool get _canGoBack => _navigationStack.length > 1;

  Widget _buildLoadingFailure({String? error}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          emptyCommentWidget(error ?? "Ошибка при загрузке", context),
          SizedBox(height: 8),
          mainButton(
            context: context,
            child: Text("Повторить"),
            onTap: () {
              _loadComments();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(child: customCircularProgressIndicator(context: context));
  }

  @override
  Widget build(BuildContext context) {
    final current = _navigationStack.last;
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.color.veryLightGray,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          buildDragHandle(context),
          buildHeader(context, current, _canGoBack, _navigateBack),
          Divider(color: context.color.darkGray),
          Expanded(
            child: BlocConsumer<CommentBloc, CommentState>(
              bloc: widget.commentBloc,
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CommentsLoading) {
                  return _buildLoading(context);
                }
                if (state is CommentsLoadingFailure) {
                  return _buildLoadingFailure();
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
                    return _buildLoadingFailure(error: state.answersError);
                  }
                  if (isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          child: commentScrollView(
                            context,
                            state,
                            _navigationStack.last,
                            scrollController,
                            ({required Comment comment}) =>
                                _navigateToAnswers(comment),
                            widget.commentBloc,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      commentCreateWidget(context, state),
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

  Widget commentCreateWidget(BuildContext context, CommentsLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
            top: 14,
            bottom: keyboardHeight + 14,
          ),
          child: Column(
            children: [
              Divider(color: context.color.darkGray),
              SizedBox(height: 14),
              mainTextField(
                context: context,
                controller: _commentController,
                style: context.theme.textTheme.bodyMedium!,
                onChanged: _commentOnChanged,
                isInputError: _isCommentError,
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 200,
                  child: mainButton(
                    context: context,
                    child: state.isCreate
                        ? Padding(
                            padding: EdgeInsets.all(6),
                            child: customCircularProgressIndicator(
                              context: context,
                            ),
                          )
                        : Text("Комментировать"),
                    onTap: () => createComment(state.post.id),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void createComment(int postId) {
    if (!_isCorrectComment()) {
      return;
    }
    widget.commentBloc.add(
      CreateComment(postId: postId, content: _commentController.text),
    );
  }

  bool _isCorrectComment() {
    if (_commentController.text.isEmpty) {
      setState(() {
        _isCommentError = true;
      });
      return false;
    }
    _isCommentError = false;
    return true;
  }

  void _commentOnChanged(String value) {
    setState(() {
      _isCommentError = false;
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
