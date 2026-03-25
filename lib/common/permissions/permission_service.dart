import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_network_flutter/common/framework/storages/preferences_storage.dart';

class PermissionService {
  final IPreferencesStorage preferencesStorage;

  PermissionService({required this.preferencesStorage});

  Future<void> markNotificationRequested() async {
    await preferencesStorage.load();
    preferencesStorage.requestNotificationPermissions = true;
    await preferencesStorage.save();
  }

  Future<bool> wasNotificationRequested() async {
    return preferencesStorage.requestNotificationPermissions ?? false;
  }

  Future<PermissionStatus> requestNotificationIfNeeded() async {
    final wasRequested = await wasNotificationRequested();
    final status = await Permission.notification.status;

    if (status.isDenied && wasRequested) {
      return status;
    }

    if (status.isPermanentlyDenied) {
      return status;
    }

    final newStatus = await Permission.notification.request();

    await markNotificationRequested();
    return newStatus;
  }

  Future<bool> requestCameraIfNeeded() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    return false;
  }

  Future<bool> canSendNotifications() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<bool> requestPhotosIfNeeded() async {
    final status = await Permission.photos.status;

    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await Permission.photos.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) return false;

    return false;
  }

  Future<bool> requestVideosIfNeeded() async {
    final status = await Permission.videos.status;

    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await Permission.videos.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) return false;

    return false;
  }

  Future<bool> requestStorageIfNeeded() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        final photosGranted = await requestPhotosIfNeeded();
        final videosGranted = await requestVideosIfNeeded();
        return photosGranted && videosGranted;
      } else {
        final status = await Permission.storage.status;
        if (status.isGranted) return true;
        if (status.isDenied) {
          final result = await Permission.storage.request();
          return result.isGranted;
        }
        return false;
      }
    } else if (Platform.isIOS) {
      return await requestPhotosIfNeeded();
    }
    return false;
  }

  Future<bool> isPhotosPermissionGranted() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  Future<bool> isVideosPermissionGranted() async {
    final status = await Permission.videos.status;
    return status.isGranted;
  }

  Future<bool> isStoragePermissionGranted() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        final photos = await Permission.photos.status;
        final videos = await Permission.videos.status;
        return photos.isGranted && videos.isGranted;
      } else {
        final status = await Permission.storage.status;
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;
      return status.isGranted;
    }
    return false;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      return deviceInfo.version.sdkInt >= 33;
    }
    return false;
  }
}
