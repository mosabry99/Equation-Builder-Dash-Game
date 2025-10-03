class SettingsManager {
  static final SettingsManager _instance = SettingsManager._internal();
  factory SettingsManager() => _instance;
  SettingsManager._internal();

  bool _isDarkMode = true;
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = false;

  bool get isDarkMode => _isDarkMode;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isMusicEnabled => _isMusicEnabled;

  void setDarkMode(bool value) {
    _isDarkMode = value;
  }

  void setSoundEnabled(bool value) {
    _isSoundEnabled = value;
  }

  void setMusicEnabled(bool value) {
    _isMusicEnabled = value;
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
  }
}
