import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  // Keys
  static const String keyFirstTime = 'first_time';
  static const String keyVolume = 'volume';
  static const String keyShuffle = 'shuffle_enabled';
  static const String keyRepeat = 'repeat_enabled';
  static const String keyLastSongPath = 'last_song_path';
  static const String keyLastPositionMs = 'last_position_ms';
  static const String keyLibraryPaths = 'library_paths';
  static const String keyLastHomeTabIndex = 'last_home_tab_index';

  // Volume
  static Future<double?> getVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyVolume);
  }

  static Future<void> setVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyVolume, volume);
  }

  // Shuffle / Repeat
  static Future<bool> getShuffleEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyShuffle) ?? false;
  }

  static Future<void> setShuffleEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyShuffle, enabled);
  }

  static Future<bool> getRepeatEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyRepeat) ?? false;
  }

  static Future<void> setRepeatEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyRepeat, enabled);
  }

  // Last played
  static Future<String?> getLastSongPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLastSongPath);
  }

  static Future<void> setLastSongPath(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastSongPath, filePath);
  }

  static Future<int> getLastPositionMs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyLastPositionMs) ?? 0;
  }

  static Future<void> setLastPositionMs(int positionMs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyLastPositionMs, positionMs);
  }

  // Library persistence
  static Future<List<String>> getLibraryPaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyLibraryPaths) ?? <String>[];
  }

  static Future<void> setLibraryPaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyLibraryPaths, paths);
  }

  // Home tab index
  static Future<int> getLastHomeTabIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyLastHomeTabIndex) ?? 0;
  }

  static Future<void> setLastHomeTabIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyLastHomeTabIndex, index);
  }
}
