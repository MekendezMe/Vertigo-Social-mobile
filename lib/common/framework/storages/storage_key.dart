import 'dart:io' show Platform;

class StorageKey {
  final String _androidKey;
  final String _iosKey;

  StorageKey({iosKey, androidKey})
    : _iosKey = iosKey ?? androidKey,
      _androidKey = androidKey ?? iosKey;

  String get key => Platform.isIOS ? _iosKey : _androidKey;
}
