import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/player_component.dart';
import '../components/falling_component.dart';
import '../components/hud_component.dart';
import '../components/explosion_effect.dart';
import '../components/success_effect.dart';
import '../managers/equation_manager.dart';
import '../managers/settings_manager.dart';
import '../managers/audio_manager.dart';
import '../widgets/game_over_dialog.dart';

class EquationBuilderGame extends FlameGame
    with HasCollisionDetection, TapDetector, PanDetector {
  late PlayerComponent player;
  late HudComponent hud;
  late EquationManager equationManager;
  final SettingsManager settings = SettingsManager();
  final AudioManager audio = AudioManager();
  
  Timer? spawnTimer;
  double spawnInterval = 2.0;
  int level = 1;
  int score = 0;
  final Random random = Random();
  bool isGameActive = true;
  bool isProcessingSuccess = false;
  
  // Dynamic background paint (updated based on theme)
  Paint backgroundPaint = Paint();
  
  void _updateBackgroundPaint() {
    final isDark = settings.isDarkMode;
    backgroundPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [
              const Color(0xFF0a0e27),
              const Color(0xFF1a1f3a),
              const Color(0xFF2a1f4a),
            ]
          : [
              const Color(0xFFe3f2fd),
              const Color(0xFFbbdefb),
              const Color(0xFF90caf9),
            ],
    ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
  }

  @override
  Color backgroundColor() => settings.isDarkMode 
      ? const Color(0xFF0a0e27)
      : const Color(0xFFe3f2fd);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize audio
    await audio.initialize();
    
    // Initialize background with current theme
    _updateBackgroundPaint();
    
    equationManager = EquationManager(level: level);
    
    player = PlayerComponent(
      position: Vector2(size.x / 2, size.y - 100),
      onCollectItem: _onCollectItem,
    );
    
    hud = HudComponent(
      equationManager: equationManager,
      onSubmit: _checkEquation,
    );
    
    add(player);
    add(hud);
    
    _startSpawning();
  }

  void _startSpawning() {
    spawnTimer?.stop();
    spawnTimer = Timer(
      spawnInterval,
      onTick: _spawnFallingItem,
      repeat: true,
    );
  }

  void _spawnFallingItem() {
    final availableValues = equationManager.getAvailableValues();
    if (availableValues.isEmpty) return;
    
    final value = availableValues[random.nextInt(availableValues.length)];
    final x = random.nextDouble() * (size.x - 60) + 30;
    
    add(FallingComponent(
      value: value,
      position: Vector2(x, -50),
      fallSpeed: 100 + (level * 20),
    ));
  }

  void _onCollectItem(String value) {
    equationManager.addToEquation(value);
    audio.playCollectSound();
    hud.updateDisplay();
    
    // Get current sum
    final currentSum = equationManager.getCurrentSum();
    final target = equationManager.getTarget();
    
    // Check conditions after every number collected
    if (currentSum < target) {
      // Continue game - sum is still below target
      return;
    } else if (currentSum == target) {
      // Exact match - show success and advance to next level
      _handleSuccess();
      return;
    } else {
      // Sum exceeds target - game over
      _showGameOverDialog();
    }
  }

  void _checkEquation() {
    final isCorrect = equationManager.validateEquation();
    
    if (isCorrect) {
      _handleSuccess();
    } else {
      _handleFailure();
    }
  }

  void _handleSuccess() {
    // Play success sound
    audio.playCorrectSound();
    
    // Add success effect
    add(SuccessEffect(position: size / 2, settings: settings));
    
    // Update score
    score += (level * 10);
    
    // Level up
    level++;
    equationManager.levelUp(level);
    spawnInterval = max(0.5, spawnInterval - 0.2);
    _startSpawning();
    
    // Clear falling items
    children.whereType<FallingComponent>().forEach((c) => c.removeFromParent());
    
    hud.updateDisplay();
  }

  void _handleFailure() {
    // Play wrong sound
    audio.playWrongSound();
    
    // Add explosion effect
    add(ExplosionEffect(position: player.position.clone(), settings: settings));
    
    // Reset equation
    equationManager.reset();
    hud.updateDisplay();
  }
  
  int getScore() {
    return score;
  }
  
  void _showGameOverDialog() {
    if (!isGameActive) return;
    isGameActive = false;
    
    // Pause spawning
    spawnTimer?.stop();
    
    // Play wrong sound
    audio.playWrongSound();
    
    // Get the overlay context
    overlays.add('gameOver');
  }
  
  void restartGame() {
    // Reset game state
    level = 1;
    score = 0;
    isGameActive = true;
    
    // Clear all falling items
    children.whereType<FallingComponent>().forEach((c) => c.removeFromParent());
    
    // Reset equation manager
    equationManager.levelUp(1);
    
    // Reset spawn interval
    spawnInterval = 2.0;
    _startSpawning();
    
    // Update HUD
    hud.updateDisplay();
    
    // Remove overlay
    overlays.remove('gameOver');
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    
    // Get tap position
    final tapX = info.eventPosition.global.x;
    final screenWidth = size.x;
    
    // Left side tap = move left, Right side tap = move right
    if (tapX < screenWidth / 2) {
      player.startMovingLeft();
    } else {
      player.startMovingRight();
    }
  }
  
  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    // Stop movement when tap is released
    player.stopMoving();
  }
  
  @override
  void onPanStart(DragStartInfo info) {
    super.onPanStart(info);
    
    // Get pan start position
    final panX = info.eventPosition.global.x;
    final screenWidth = size.x;
    
    // Left side = move left continuously, Right side = move right continuously
    if (panX < screenWidth / 2) {
      player.startMovingLeft();
    } else {
      player.startMovingRight();
    }
  }
  
  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    
    // Update movement direction based on current pan position
    final panX = info.eventPosition.global.x;
    final screenWidth = size.x;
    
    if (panX < screenWidth / 2) {
      player.startMovingLeft();
    } else {
      player.startMovingRight();
    }
  }
  
  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    // Stop movement when pan ends
    player.stopMoving();
  }
  
  @override
  void onPanCancel() {
    super.onPanCancel();
    // Stop movement if pan is cancelled
    player.stopMoving();
  }

  @override
  void update(double dt) {
    super.update(dt);
    spawnTimer?.update(dt);
    
    // Remove falling items that went off screen
    children.whereType<FallingComponent>().forEach((component) {
      if (component.position.y > size.y + 100) {
        component.removeFromParent();
      }
    });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      backgroundPaint,
    );
    super.render(canvas);
  }
}
