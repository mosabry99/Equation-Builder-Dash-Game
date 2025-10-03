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

class EquationBuilderGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  late PlayerComponent player;
  late HudComponent hud;
  late EquationManager equationManager;
  final SettingsManager settings = SettingsManager();
  
  Timer? spawnTimer;
  double spawnInterval = 2.0;
  int level = 1;
  int score = 0;
  final Random random = Random();
  bool isGameActive = true;
  bool isProcessingSuccess = false;
  
  // Neon gradient background
  final Paint backgroundPaint = Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0a0e27),
        Color(0xFF1a1f3a),
        Color(0xFF2a1f4a),
      ],
    ).createShader(const Rect.fromLTWH(0, 0, 1000, 2000));

  @override
  Color backgroundColor() => const Color(0xFF0a0e27);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
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
    hud.updateDisplay();
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
    // Add explosion effect
    add(ExplosionEffect(position: player.position.clone(), settings: settings));
    
    // Reset equation
    equationManager.reset();
    hud.updateDisplay();
  }
  
  int getScore() {
    return score;
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.moveLeft();
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.moveRight();
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.enter) ||
          keysPressed.contains(LogicalKeyboardKey.space)) {
        _checkEquation();
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.backspace)) {
        equationManager.removeLastFromEquation();
        hud.updateDisplay();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
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
