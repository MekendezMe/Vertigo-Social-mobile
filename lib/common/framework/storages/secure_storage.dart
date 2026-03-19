import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_flutter/common/framework/storages/storage_key.dart';

abstract class ISecureStorage {
  String? accessToken;
  Future<void> clear();
  Future<void> load();
  Future<void> save();
}

class SecureStorage extends ISecureStorage {
  /// Инициализация secure storage
  late final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      resetOnError: true,
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      accountName: null,
    ),
  );

  final _accessTokenKey = StorageKey(iosKey: "accessToken");
  var _isLoaded = false;
  @override
  Future<void> clear() async {
    accessToken = null;

    // await Future.wait([_delete(key: _sessionKey)]);

    await _clearLegacyKeys();
  }

  @override
  Future<void> load() async {
    accessToken = await _read(key: _accessTokenKey);

    _isLoaded = true;
  }

  @override
  Future<void> save() async {
    if (!_isLoaded) {
      throw ("""
      Обнаружена попытка сохранить SecureStorage без предварительной загрузки. 
      """);
    }
    await _write(key: _accessTokenKey, value: accessToken);
  }

  Future<String?> _read({required StorageKey key}) async {
    return await _storage.read(key: key.key);
  }

  Future<void> _write({required StorageKey key, required String? value}) async {
    if (value == null) {
      await _storage.delete(key: key.key);
    } else {
      await _storage.write(key: key.key, value: value);
    }
  }

  Future<void> _delete({required StorageKey key}) async {
    return await _storage.delete(key: key.key);
  }

  Future<void> _clearLegacyKeys() async {
    if (Platform.isAndroid) {
      final prefs = await SharedPreferences.getInstance();
      // if (prefs.containsKey(_sessionKey)) {
      //   await prefs.setString(_sessionKey, "");
      // }
    }
  }
}
