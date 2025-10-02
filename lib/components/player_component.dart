import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerComponent extends PositionComponent with HasGameRef, CollisionCallbacks {
  final void Function(String value) onCollectItem;
  double moveSpeed = 300.0;
  Vector2 velocity = Vector2.zero();
  
  final Paint playerPaint = Paint()
    ..color = const Color(0xFF00ffff)
    ..style = PaintingStyle.fill;
    
  final Paint glowPaint = Paint()
    ..color = const Color(0xFF00ffff).withOpacity(0.3)
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

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
    add(RectangleHitbox());
  }

  void moveLeft() {
    velocity.x = -moveSpeed;
  }

  void moveRight() {
    velocity.x = moveSpeed;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Apply velocity
    position.add(velocity * dt);
    
    // Boundary checking
    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    } else if (position.x > gameRef.size.x - size.x / 2) {
      position.x = gameRef.size.x - size.x / 2;
    }
    
    // Damping
    velocity.x *= 0.85;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw glow effect
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: (size / 2).toOffset(),
          width: size.x + 10,
          height: size.y + 10,
        ),
        const Radius.circular(12),
      ),
      glowPaint,
    );
    
    // Draw player
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
