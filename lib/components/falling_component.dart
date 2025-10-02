import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'player_component.dart';

class FallingComponent extends PositionComponent with HasGameRef, CollisionCallbacks {
  final String value;
  final double fallSpeed;
  bool collected = false;
  
  final Paint bgPaint = Paint()
    ..color = const Color(0xFF6c5ce7)
    ..style = PaintingStyle.fill;
    
  final Paint glowPaint = Paint()
    ..color = const Color(0xFF6c5ce7).withOpacity(0.4)
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

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
    
    // Draw glow
    canvas.drawCircle(
      (size / 2).toOffset(),
      size.x / 2 + 5,
      glowPaint,
    );
    
    // Draw background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: (size / 2).toOffset(),
          width: size.x,
          height: size.y,
        ),
        const Radius.circular(10),
      ),
      bgPaint,
    );
    
    // Draw value
    final textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black54,
              offset: Offset(2, 2),
              blurRadius: 3,
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
  }
}
