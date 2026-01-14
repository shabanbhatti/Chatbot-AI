import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  const SharedPreferencesService({required this.sharedPreferences});

  Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  Future<String> getString(String key) async {
    return sharedPreferences.getString(key) ?? '';
  }

  Future<void> setBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    return sharedPreferences.getBool(key) ?? false;
  }

  Future<void> setInt(String key, int value) async {
    await sharedPreferences.setInt(key, value);
  }

  Future<int> getInt(String key) async {
    return sharedPreferences.getInt(key) ?? 0;
  }
}

abstract class SharedPreferencesKEYS {
  static const String loggedKey = 'logged_key';
  static const String themeKey = 'theme';
  static const String newChatKey = 'newChatKey';
  static const String accentColorKey = 'accent_color';
  static const String chatRoomIdKey = 'chat_room_id';
}
