import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SuccessEffect extends PositionComponent with HasGameReference {
  final Random _random = Random();
  final List<_Confetti> confetti = [];
  double lifetime = 0;
  final double maxLifetime = 2.0;

  SuccessEffect({required Vector2 position})
      : super(
          position: position,
          anchor: Anchor.center,
          priority: 50,
        ) {
    _generateConfetti();
  }

  void _generateConfetti() {
    for (int i = 0; i < 50; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 300 + 150;
      
      confetti.add(_Confetti(
        position: Vector2.zero(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        color: _getRandomConfettiColor(),
        size: _random.nextDouble() * 6 + 3,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: _random.nextDouble() * 4 - 2,
      ));
    }
  }

  Color _getRandomConfettiColor() {
    final colors = [
      const Color(0xFF00ffff),
      const Color(0xFFffd93d),
      const Color(0xFF6c5ce7),
      const Color(0xFFff6b6b),
      const Color(0xFF26de81),
      const Color(0xFFfe9c8f),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    lifetime += dt;
    
    // Update confetti
    for (var piece in confetti) {
      piece.update(dt);
    }
    
    // Remove effect after lifetime
    if (lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw confetti
    for (var piece in confetti) {
      piece.render(canvas);
    }
    
    // Draw success text
    if (lifetime < 1.5) {
      final opacity = (1.5 - lifetime).clamp(0.0, 1.0);
      final yOffset = -50 - (lifetime * 30);
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: '✨ CORRECT! ✨',
          style: TextStyle(
            color: Colors.white.withValues(alpha: opacity),
            fontSize: 32,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: const Color(0xFF00ffff).withValues(alpha: opacity),
                offset: const Offset(0, 0),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, yOffset - textPainter.height / 2),
      );
    }
  }
}

class _Confetti {
  Vector2 position;
  Vector2 velocity;
  Color color;
  double size;
  double rotation;
  double rotationSpeed;
  double life = 1.0;

  _Confetti({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });

  void update(double dt) {
    position.add(velocity * dt);
    velocity.y += 400 * dt; // Gravity
    velocity.scale(0.99); // Friction
    rotation += rotationSpeed * dt;
    life -= dt * 0.5;
  }

  void render(Canvas canvas) {
    if (life > 0) {
      canvas.save();
      canvas.translate(position.x, position.y);
      canvas.rotate(rotation);
      
      final paint = Paint()
        ..color = color.withValues(alpha: life.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      
      // Draw rectangle confetti
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size * 2, height: size),
        paint,
      );
      
      canvas.restore();
    }
  }
}
