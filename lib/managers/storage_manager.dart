import 'package:shared_preferences.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  StorageManager._internal();

  SharedPreferences? _prefs;

  // Keys
  static const String _keyLevel = 'game_level';
  static const String _keyScore = 'game_score';
  static const String _keyHighScore = 'high_score';
  static const String _keyTotalGames = 'total_games';
  static const String _keyLanguage = 'app_language';

  // Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Level
  int getLevel() {
    return _prefs?.getInt(_keyLevel) ?? 1;
  }

  Future<void> saveLevel(int level) async {
    await _prefs?.setInt(_keyLevel, level);
  }

  // Score
  int getScore() {
    return _prefs?.getInt(_keyScore) ?? 0;
  }

  Future<void> saveScore(int score) async {
    await _prefs?.setInt(_keyScore, score);
    
    // Update high score if current score is higher
    final highScore = getHighScore();
    if (score > highScore) {
      await saveHighScore(score);
    }
  }

  // High Score
  int getHighScore() {
    return _prefs?.getInt(_keyHighScore) ?? 0;
  }

  Future<void> saveHighScore(int score) async {
    await _prefs?.setInt(_keyHighScore, score);
  }

  // Total Games
  int getTotalGames() {
    return _prefs?.getInt(_keyTotalGames) ?? 0;
  }

  Future<void> incrementTotalGames() async {
    final total = getTotalGames() + 1;
    await _prefs?.setInt(_keyTotalGames, total);
  }

  // Language
  String getLanguage() {
    return _prefs?.getString(_keyLanguage) ?? 'en';
  }

  Future<void> saveLanguage(String languageCode) async {
    await _prefs?.setString(_keyLanguage, languageCode);
  }

  // Reset game progress
  Future<void> resetProgress() async {
    await saveLevel(1);
    await saveScore(0);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
