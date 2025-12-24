import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  const SharedPreferencesService({required this.sharedPreferences});

  Future<void> setBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    return sharedPreferences.getBool(key) ?? false;
  }
}

abstract class SharedPreferencesKEYS {
  static const String loggedKey = 'logged_key';
}
