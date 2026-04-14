import 'dart:io';

bool isVideoByUrl(String url) {
  final videoExtensions = [
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.webm',
    '.flv',
    '.wmv',
  ];
  final lowerUrl = url.toLowerCase();
  return videoExtensions.any((ext) => lowerUrl.endsWith(ext));
}

bool isImageByUrl(String url) {
  final imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
    '.svg',
  ];
  final lowerUrl = url.toLowerCase();
  return imageExtensions.any((ext) => lowerUrl.endsWith(ext));
}

bool isVideoByFile(File file) {
  const videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
  return videoExtensions.any((ext) => file.path.toLowerCase().endsWith(ext));
}
