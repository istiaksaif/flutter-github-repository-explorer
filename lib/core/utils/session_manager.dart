import 'package:get_storage/get_storage.dart';

const String kIsFirstTime = 'firstTime';
const String kIsRated = 'app_rated';

/// Lightweight wrapper around GetStorage for simple session flags/preferences.
class SessionManager {
  SessionManager._();

  static GetStorage _preferences = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
    _preferences = GetStorage();
  }

  static void setValue(String key, dynamic value) {
    _preferences.write(key, value);
  }

  static dynamic getValue(String key, {dynamic defaultValue}) {
    return _preferences.read(key) ?? defaultValue;
  }

  static Future<void> removeValue(String key) async {
    await _preferences.remove(key);
  }
}
