import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../managers/settings_manager.dart';
import '../managers/theme_manager.dart';

class PlayerComponent extends PositionComponent with HasGameReference, CollisionCallbacks {
  final void Function(String value) onCollectItem;
  double moveSpeed = 300.0;
  Vector2 velocity = Vector2.zero();
  double animationTime = 0.0;
  final SettingsManager settings = SettingsManager();
  late GameTheme theme;

  PlayerComponent({
    required Vector2 position,
    required this.onCollectItem,
  }) : super(
          position: position,
          size: Vector2(60, 60),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    theme = GameTheme(isDark: settings.isDarkMode);
    add(RectangleHitbox());
  }

  // Continuous movement methods
  void startMovingLeft() {
    velocity.x = -moveSpeed;
  }

  void startMovingRight() {
    velocity.x = moveSpeed;
  }
  
  void stopMoving() {
    velocity.x = 0;
  }
  
  // Legacy single-tap methods (now call continuous methods)
  void moveLeft() {
    startMovingLeft();
  }

  void moveRight() {
    startMovingRight();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    animationTime += dt;
    
    // Apply velocity
    position.add(velocity * dt);
    
    // Boundary checking
    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    } else if (position.x > game.size.x - size.x / 2) {
      position.x = game.size.x - size.x / 2;
    }
    
    // Damping
    velocity.x *= 0.85;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Update theme
    theme = GameTheme(isDark: settings.isDarkMode);
    
    // Pulse animation
    final pulseScale = 1.0 + math.sin(animationTime * 3) * 0.05;
    
    // Draw glow effect with pulse
    final glowPaint = Paint()
      ..color = theme.playerGlow
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: (size / 2).toOffset(),
          width: (size.x + 15) * pulseScale,
          height: (size.y + 15) * pulseScale,
        ),
        Radius.circular(12 * pulseScale),
      ),
      glowPaint,
    );
    
    // Draw gradient background
    final playerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.playerColor,
          theme.playerColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromCenter(
        center: (size / 2).toOffset(),
        width: size.x,
        height: size.y,
      ));
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: (size / 2).toOffset(),
          width: size.x,
          height: size.y,
        ),
        const Radius.circular(10),
      ),
      playerPaint,
    );
    
    // Draw border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: (size / 2).toOffset(),
          width: size.x,
          height: size.y,
        ),
        const Radius.circular(10),
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    
    // Draw eyes
    final eyePaint = Paint()..color = const Color(0xFF0a0e27);
    canvas.drawCircle(
      Offset(size.x * 0.35, size.y * 0.4),
      4,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(size.x * 0.65, size.y * 0.4),
      4,
      eyePaint,
    );
    
    // Draw smile
    final smilePath = Path();
    smilePath.moveTo(size.x * 0.3, size.y * 0.6);
    smilePath.quadraticBezierTo(
      size.x * 0.5,
      size.y * 0.7,
      size.x * 0.7,
      size.y * 0.6,
    );
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF0a0e27)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }
}
