import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_flutter/common/framework/storages/storage_key.dart';
import 'package:social_network_flutter/common/framework/permissions/permission_strings.dart';

abstract class IPreferencesStorage {
  bool? requestNotificationPermissions;
  String? pendingNotification;
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
  final _pendingNotificationKey = StorageKey(
    androidKey: pendingNotificationKey,
    iosKey: pendingNotificationKey,
  );

  @override
  Future<void> clear() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    // Удаление не работает на Android, сбрасываем к значениям по умолчанию
    // await sharedPreferences.setInt(_test.key, 0);
    await sharedPreferences.setBool(
      _requestNotificationPermissionKey.key,
      false,
    );
    await sharedPreferences.setString(_pendingNotificationKey.key, "");
    await load();
  }

  @override
  Future<void> load() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    requestNotificationPermissions =
        sharedPreferences.getBool(_requestNotificationPermissionKey.key) ??
        false;
    pendingNotification = sharedPreferences.getString(
      _pendingNotificationKey.key,
    );
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
    await _write(key: _pendingNotificationKey.key, value: pendingNotification);
  }

  Future<void> _write<T>({required String key, required T? value}) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }
}
