import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_service.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();
  final PermissionService permissionService;

  MediaService({required this.permissionService});

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      debugPrint('Ошибка при съемке: $e');
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      debugPrint('Ошибка при выборе фото: $e');
      return null;
    }
  }

  Future<List<File>> pickMultiImageFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        limit: 10,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      final List<File> convertImages = images
          .map((image) => File(image.path))
          .toList();
      return convertImages;
    } catch (e) {
      debugPrint('Ошибка при выборе фото: $e');
      return [];
    }
  }

  Future<List<File>> pickMultipleMedia({
    bool allowImage = true,
    bool allowVideos = true,
  }) async {
    try {
      final medias = await _picker.pickMultipleMedia();

      return medias.map((media) => File(media.path)).toList();

      // FilePickerResult? result = await FilePicker.pickFiles(
      //   type: FileType.media,
      //   allowMultiple: true,
      // );
      // if (result == null) return [];
      // return result.paths.map((path) => File(path!)).toList();
    } catch (e) {
      debugPrint('Ошибка выбора медиа: $e');
      return [];
    }
  }

  Future<File?> pickVideoFromGallery() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 2),
      );
      return video != null ? File(video.path) : null;
    } catch (e) {
      debugPrint('Ошибка при выборе видео: $e');
      return null;
    }
  }

  Future<File?> takePhotoWithPermission() async {
    final hasPermission = await permissionService.requestCameraIfNeeded();
    if (!hasPermission) {
      debugPrint('Нет разрешения на камеру');
      return null;
    }
    return await pickImageFromCamera();
  }

  Future<List<File>?> pickMediaWithPermission() async {
    final hasPermission = await permissionService.requestPhotosIfNeeded();
    if (!hasPermission) {
      debugPrint('Нет разрешения на галерею');
      return null;
    }
    final hasVideoPermission = await permissionService.requestVideosIfNeeded();
    if (!hasVideoPermission) {
      debugPrint('Нет разрешения на галерею');
      return null;
    }
    return await pickMultipleMedia();
  }

  Future<File?> pickPhotoWithPermission() async {
    final hasPermission = await permissionService.requestPhotosIfNeeded();
    if (!hasPermission) {
      debugPrint('Нет разрешения на галерею');
      return null;
    }
    return await pickImageFromGallery();
  }

  Future<List<File>>? pickPhotosWithPermission() async {
    final hasPermission = await permissionService.requestPhotosIfNeeded();
    if (!hasPermission) {
      debugPrint('Нет разрешения на галерею');
      return [];
    }
    return await pickMultiImageFromGallery();
  }
}

class MediaFile {
  final String path;
  final String mimeType;
  final bool isImage;
  final bool isVideo;

  MediaFile({required this.path, required this.mimeType})
    : isImage = mimeType.startsWith('image/'),
      isVideo = mimeType.startsWith('video/');

  factory MediaFile.fromXFile(XFile file) {
    return MediaFile(path: file.path, mimeType: file.mimeType ?? 'unknown');
  }

  File get file => File(path);
}
