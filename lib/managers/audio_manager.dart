import 'package:flame_audio/flame_audio.dart';
import 'settings_manager.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final SettingsManager _settings = SettingsManager();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Pre-load audio files
      await FlameAudio.audioCache.loadAll([
        'collect.mp3',
        'click.mp3',
        'background.mp3',
      ]);
      _isInitialized = true;
      
      // Start background music if enabled
      if (_settings.isMusicEnabled) {
        playBackgroundMusic();
      }
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  void playCollectSound() {
    if (_settings.isSoundEnabled && _isInitialized) {
      try {
        FlameAudio.play('collect.mp3', volume: 0.5);
      } catch (e) {
        print('Error playing collect sound: $e');
      }
    }
  }

  void playCorrectSound() {
    if (_settings.isSoundEnabled && _isInitialized) {
      try {
        // Using collect sound as placeholder since correct.mp3 doesn't exist yet
        FlameAudio.play('collect.mp3', volume: 0.7);
      } catch (e) {
        print('Error playing correct sound: $e');
      }
    }
  }

  void playWrongSound() {
    if (_settings.isSoundEnabled && _isInitialized) {
      try {
        // Using click sound as placeholder since wrong.mp3 doesn't exist yet
        FlameAudio.play('click.mp3', volume: 0.6);
      } catch (e) {
        print('Error playing wrong sound: $e');
      }
    }
  }

  void playClickSound() {
    if (_settings.isSoundEnabled && _isInitialized) {
      try {
        FlameAudio.play('click.mp3', volume: 0.3);
      } catch (e) {
        print('Error playing click sound: $e');
      }
    }
  }

  void playBackgroundMusic() {
    if (_settings.isMusicEnabled && _isInitialized) {
      try {
        FlameAudio.bgm.play('background.mp3', volume: 0.2);
      } catch (e) {
        print('Error playing background music: $e');
      }
    }
  }

  void stopBackgroundMusic() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }

  void pauseBackgroundMusic() {
    try {
      FlameAudio.bgm.pause();
    } catch (e) {
      print('Error pausing background music: $e');
    }
  }

  void resumeBackgroundMusic() {
    if (_settings.isMusicEnabled && _isInitialized) {
      try {
        FlameAudio.bgm.resume();
      } catch (e) {
        print('Error resuming background music: $e');
      }
    }
  }

  void dispose() {
    stopBackgroundMusic();
  }
}
