enum PostType { all, recommended, subscribe }

String getPostType(PostType postType) {
  switch (postType) {
    case PostType.all:
      return "all";
    case PostType.recommended:
      return "recommended";
    case PostType.subscribe:
      return "subscribe";
  }
}
