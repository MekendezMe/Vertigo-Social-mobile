import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_flutter/common/framework/storages/storage_key.dart';
import 'package:social_network_flutter/common/permissions/permission_strings.dart';

abstract class IPreferencesStorage {
  bool? requestNotificationPermissions;
  bool? requestCameraPermissions;
  Future<void> clear();
  Future<void> load();
  Future<void> save();
}

class PreferencesStorage extends IPreferencesStorage {
  var _isLoaded = false;
  final _requestNotificationPermissionKey = StorageKey(
    androidKey: notificationRequestedKey,
    iosKey: notificationRequestedKey,
  );
  // final _requestCameraPermissionKey = StorageKey(
  //   androidKey: cameraRequestedKey,
  //   iosKey: cameraRequestedKey,
  // );

  @override
  Future<void> clear() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    // Удаление не работает на Android, сбрасываем к значениям по умолчанию
    // await sharedPreferences.setInt(_test.key, 0);
    await load();
  }

  @override
  Future<void> load() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    requestNotificationPermissions =
        sharedPreferences.getBool(_requestNotificationPermissionKey.key) ??
        false;
    // requestCameraPermissions =
    //     sharedPreferences.getBool(_requestCameraPermissionKey.key) ?? false;
    _isLoaded = true;
  }

  @override
  Future<void> save() async {
    if (!_isLoaded) {
      throw ("""
      Обнаружена попытка сохранить PreferencesStorage без предварительной загрузки.
      """);
    }
    await _write(
      key: _requestNotificationPermissionKey.key,
      value: requestNotificationPermissions,
    );
  }

  Future<void> _write({required String key, required bool? value}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (value == null) {
      await sharedPreferences.setBool(key, false);
    } else {
      await sharedPreferences.setBool(key, value);
    }
  }
}
