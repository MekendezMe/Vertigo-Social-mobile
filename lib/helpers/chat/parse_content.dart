String parseContent(Object content) {
  if (content is! Map) {
    return "";
  }
  return content['text'] as String? ?? "";
}
