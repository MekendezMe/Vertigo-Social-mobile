import 'package:flutter/material.dart';
import 'package:social_network_flutter/comment/logic/bloc/comment_bloc.dart';
import 'package:social_network_flutter/comment/logic/entities/comment.dart';
import 'package:social_network_flutter/comment/logic/helpers/navigation_type_helper.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';
import 'package:social_network_flutter/ui/widgets/button/main_button.dart';
import 'package:social_network_flutter/ui/widgets/custom_circular_progress_indicator.dart';
import 'package:social_network_flutter/ui/widgets/text_field/main_text_field.dart';

class CommentCreateWidget extends StatefulWidget {
  const CommentCreateWidget({
    super.key,
    required this.state,
    required this.current,
    this.replyingComment,
    this.rootComment,
    required this.commentBloc,
    required this.onCloseAnswerPressed,
    required this.isAnswer,
    required this.commentFocusNode,
    required this.controller,
  });
  final CommentsLoaded state;
  final NavigationItem current;
  final bool isAnswer;
  final FocusNode commentFocusNode;
  final TextEditingController controller;
  final Comment? replyingComment;
  final Comment? rootComment;
  final CommentBloc commentBloc;
  final Function() onCloseAnswerPressed;

  @override
  State<CommentCreateWidget> createState() => _CommentCreateWidgetState();
}

class _CommentCreateWidgetState extends State<CommentCreateWidget> {
  bool _isCommentError = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isComments = widget.current.type == NavigationType.comments;
    bool isCreate = isComments
        ? widget.state.isCreate
        : widget.state.isAnswersCreate;
    final answerText = widget.isAnswer && widget.replyingComment != null
        ? "Ответ @${widget.replyingComment!.author.username} "
        : "";
    String buttonText = isComments && !widget.isAnswer
        ? "Комментировать"
        : "Ответить";
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
              Divider(color: context.color.darkGray, height: 1, thickness: 0.5),
              if (widget.isAnswer && widget.replyingComment != null)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.onCloseAnswerPressed();
                      },
                      style: IconButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                      ),
                      icon: Row(
                        children: [
                          Text(
                            answerText,
                            style: context.theme.textTheme.bodyMedium!.modify(
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.close,
                            size: 20,
                            color: context.color.darkGray,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (!widget.isAnswer) SizedBox(height: 20),
              mainTextField(
                context: context,
                controller: widget.controller,
                style: context.theme.textTheme.bodyMedium!,
                focusNode: widget.commentFocusNode,
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
                    child: isCreate
                        ? Padding(
                            padding: EdgeInsets.all(6),
                            child: customCircularProgressIndicator(
                              context: context,
                            ),
                          )
                        : Text(buttonText),
                    onTap: isComments && !widget.isAnswer
                        ? () => createComment(widget.state.post.id)
                        : () {
                            if (widget.rootComment == null) return;
                            int authorId = widget.replyingComment != null
                                ? widget.replyingComment!.author.id
                                : widget.rootComment!.author.id;
                            createAnswer(
                              widget.rootComment!.id,
                              widget.state.post.id,
                              authorId,
                              widget.replyingComment?.id,
                            );
                          },
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
    final content = _convertContent(widget.controller.text);
    widget.commentBloc.add(CreateComment(postId: postId, content: content));
  }

  String _convertContent(String content) {
    if (!content.startsWith("@")) return content;

    int spaceIndex = content.indexOf(' ');
    if (spaceIndex == -1) return content;

    final String author = content.substring(1, spaceIndex);
    final String rest = content.substring(spaceIndex + 1).trim();
    final comment = widget.replyingComment ?? widget.rootComment;
    if (comment == null) return content;
    final commentAuthorUsername = comment.author.username;
    if (commentAuthorUsername == author.trim()) {
      return rest;
    }

    return content;
  }

  void createAnswer(
    int commentId,
    int postId,
    int userId,
    int? replyingCommentId,
  ) {
    if (!_isCorrectComment()) {
      return;
    }
    final content = _convertContent(widget.controller.text);
    widget.commentBloc.add(
      CreateAnswer(
        commentId: commentId,
        content: content,
        postId: postId,
        userId: userId,
        replyingCommentId: replyingCommentId,
      ),
    );
  }

  bool _isCorrectComment() {
    if (widget.controller.text.isEmpty) {
      setState(() {
        _isCommentError = true;
      });
      return false;
    }
    setState(() {
      _isCommentError = false;
    });

    return true;
  }

  void _commentOnChanged(String value) {
    setState(() {
      _isCommentError = false;
    });
  }
}
