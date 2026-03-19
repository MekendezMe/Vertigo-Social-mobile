import 'package:shared_preferences/shared_preferences.dart';

abstract class IPreferencesStorage {
  Future<void> clear();
  Future<void> load();
  Future<void> save();
}

class PreferencesStorage extends IPreferencesStorage {
  var _isLoaded = false;
  @override
  Future<void> clear() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    // Удаление не работает на Android, т.ч. сбрасываем к значениям по-умолчанию
    // await sharedPreferences.setInt(_test.key, 0);
    await load();
  }

  @override
  Future<void> load() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    //test = sharedPreferences.getBool(_test.key) ?? false;
    _isLoaded = true;
  }

  @override
  Future<void> save() async {
    if (!_isLoaded) {
      throw ("""
      Обнаружена попытка сохранить PreferencesStorage без предварительной загрузки.
      """);
    }
    final sharedPreferences = await SharedPreferences.getInstance();

    // await sharedPreferences.setOptionalBool(_test.key, _test);
  }
}
