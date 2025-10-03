import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'player_component.dart';
import '../managers/settings_manager.dart';
import '../managers/theme_manager.dart';

class FallingComponent extends PositionComponent with HasGameReference, CollisionCallbacks {
  final String value;
  final double fallSpeed;
  bool collected = false;
  double animationTime = 0.0;
  double rotation = 0.0;
  final SettingsManager settings = SettingsManager();
  late GameTheme theme;
  
  // Helper getters
  bool get _isOperator => ['+', '-', '*', '/'].contains(value);
  
  Color get itemColor {
    theme = GameTheme(isDark: settings.isDarkMode);
    return _isOperator ? theme.operatorColor : theme.numberColor;
  }

  FallingComponent({
    required this.value,
    required Vector2 position,
    required this.fallSpeed,
  }) : super(
          position: position,
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += fallSpeed * dt;
    animationTime += dt;
    rotation += dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is PlayerComponent && !collected) {
      collected = true;
      other.onCollectItem(value);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(math.sin(rotation) * 0.1); // Gentle wobble
    canvas.translate(-size.x / 2, -size.y / 2);
    
    // Pulse effect
    final pulseScale = 1.0 + math.sin(animationTime * 3) * 0.05;
    
    // Draw outer glow with pulse
    final glowPaint = Paint()
      ..color = itemColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(
      (size / 2).toOffset(),
      (size.x / 2 + 8) * pulseScale,
      glowPaint,
    );
    
    // Draw background with gradient
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: (size / 2).toOffset(),
        width: size.x * pulseScale,
        height: size.y * pulseScale,
      ),
      Radius.circular(12 * pulseScale),
    );
    
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          itemColor,
          itemColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromCenter(
        center: (size / 2).toOffset(),
        width: size.x,
        height: size.y,
      ));
    
    canvas.drawRRect(bgRect, gradientPaint);
    
    // Draw border
    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    
    // Draw sparkle effect for operators
    if (_isOperator) {
      final sparkleTime = animationTime * 4;
      final sparkleOpacity = (math.sin(sparkleTime) * 0.5 + 0.5) * 0.3;
      
      final sparklePaint = Paint()
        ..color = Colors.white.withValues(alpha: sparkleOpacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(size.x * 0.25, size.y * 0.25),
        2,
        sparklePaint,
      );
      canvas.drawCircle(
        Offset(size.x * 0.75, size.y * 0.75),
        2,
        sparklePaint,
      );
    }
    
    // Draw value
    final textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: Colors.white,
          fontSize: _isOperator ? 28 : 26,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.5),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
            Shadow(
              color: itemColor.withValues(alpha: 0.8),
              offset: Offset.zero,
              blurRadius: 10,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
    
    canvas.restore();
  }
}
