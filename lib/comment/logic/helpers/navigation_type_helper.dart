enum NavigationType { comments, answers }

class NavigationItem {
  final NavigationType type;
  final int? postId;
  final int? commentId;

  NavigationItem._({required this.type, this.postId, this.commentId});

  factory NavigationItem.comments({required int postId}) {
    return NavigationItem._(type: NavigationType.comments, postId: postId);
  }

  factory NavigationItem.answers({required int commentId}) {
    return NavigationItem._(type: NavigationType.answers, commentId: commentId);
  }
}
