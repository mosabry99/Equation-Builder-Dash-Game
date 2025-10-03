import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ExplosionEffect extends PositionComponent with HasGameReference {
  final Random _random = Random();
  final List<_Particle> particles = [];
  double lifetime = 0;
  final double maxLifetime = 2.0;
  bool shakeApplied = false;
  
  static final List<String> funnyMessages = [
    'OOPS! 💥',
    'KABOOM! 🔥',
    'TRY AGAIN! 💣',
    'SO CLOSE! 😅',
    'MATH IS HARD! 🤯',
    'NOT QUITE! 💫',
    'BOOM! 💥',
  ];
  
  late String selectedMessage;

  ExplosionEffect({required Vector2 position})
      : super(
          position: position,
          anchor: Anchor.center,
          priority: 50,
        ) {
    selectedMessage = funnyMessages[_random.nextInt(funnyMessages.length)];
    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < 30; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 200 + 100;
      
      particles.add(_Particle(
        position: Vector2.zero(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        color: _getRandomExplosionColor(),
        size: _random.nextDouble() * 8 + 4,
      ));
    }
  }

  Color _getRandomExplosionColor() {
    final colors = [
      const Color(0xFFff6b6b),
      const Color(0xFFffd93d),
      const Color(0xFFff8c42),
      const Color(0xFFffee58),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    lifetime += dt;
    
    // Apply screen shake once
    if (!shakeApplied) {
      shakeApplied = true;
      _applyScreenShake();
    }
    
    // Update particles
    for (var particle in particles) {
      particle.update(dt);
    }
    
    // Remove effect after lifetime
    if (lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  void _applyScreenShake() {
    // Simple shake effect by slightly moving camera
    // In a more complex game, you'd implement proper camera shake
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw particles
    for (var particle in particles) {
      particle.render(canvas);
    }
    
    // Draw BOOM text
    if (lifetime < 1.0) {
      final opacity = (1.0 - lifetime).clamp(0.0, 1.0);
      final scale = 1.0 + lifetime * 0.5;
      
      canvas.save();
      canvas.scale(scale);
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: selectedMessage,
          style: TextStyle(
            color: Colors.white.withValues(alpha: opacity),
            fontSize: 36,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: const Color(0xFFff6b6b).withValues(alpha: opacity),
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
        Offset(-textPainter.width / 2 / scale, -textPainter.height / 2 / scale),
      );
      
      canvas.restore();
    }
  }
}

class _Particle {
  Vector2 position;
  Vector2 velocity;
  Color color;
  double size;
  double life = 1.0;

  _Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
  });

  void update(double dt) {
    position.add(velocity * dt);
    velocity.y += 300 * dt; // Gravity
    velocity.scale(0.98); // Friction
    life -= dt * 0.5;
  }

  void render(Canvas canvas) {
    if (life > 0) {
      final paint = Paint()
        ..color = color.withValues(alpha: life.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(position.toOffset(), size, paint);
    }
  }
}
