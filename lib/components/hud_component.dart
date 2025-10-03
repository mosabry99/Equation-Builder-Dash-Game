import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../managers/equation_manager.dart';
import '../managers/settings_manager.dart';

class HudComponent extends PositionComponent with HasGameReference {
  final EquationManager equationManager;
  final VoidCallback onSubmit;
  final SettingsManager settings = SettingsManager();
  
  final Paint glassPaint = Paint()
    ..color = const Color(0xFF1a1f3a).withValues(alpha: 0.85)
    ..style = PaintingStyle.fill;
    
  final Paint borderPaint = Paint()
    ..color = const Color(0xFF00ffff).withValues(alpha: 0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  HudComponent({
    required this.equationManager,
    required this.onSubmit,
  }) : super(
          priority: 100,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(20, 40);
    size = Vector2(gameRef.size.x - 40, 120);
  }

  void updateDisplay() {
    // Force re-render
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw glassmorphism background with enhanced glow
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(20),
    );
    
    // Draw outer glow
    final glowPaint = Paint()
      ..color = (settings.isDarkMode
              ? const Color(0xFF00ffff)
              : const Color(0xFF1976d2))
          .withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawRRect(rrect, glowPaint);
    
    canvas.drawRRect(rrect, glassPaint);
    canvas.drawRRect(rrect, borderPaint);
    
    // Draw level and score in row
    _drawText(
      canvas,
      'LV ${equationManager.getLevel()}',
      20,
      15,
      18,
      const Color(0xFFffd93d),
      FontWeight.bold,
    );
    
    // Draw score on the right
    final scoreText = 'SCORE: ${_getScore()}';
    final scorePainter = TextPainter(
      text: TextSpan(
        text: scoreText,
        style: const TextStyle(
          color: Color(0xFF26de81),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    scorePainter.layout();
    scorePainter.paint(canvas, Offset(size.x - scorePainter.width - 20, 15));
    
    // Draw target with enhanced styling
    _drawText(
      canvas,
      'TARGET: ${equationManager.getTarget()}',
      20,
      50,
      26,
      settings.isDarkMode ? const Color(0xFF00ffff) : const Color(0xFF1976d2),
      FontWeight.bold,
    );
    
    // Draw current equation with box
    final equation = equationManager.getEquationString();
    final equationRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(15, 85, size.x - 30, 35),
      const Radius.circular(10),
    );
    
    final equationBoxPaint = Paint()
      ..color = (settings.isDarkMode
              ? Colors.black26
              : Colors.white24);
    canvas.drawRRect(equationRect, equationBoxPaint);
    
    _drawText(
      canvas,
      equation.isEmpty ? 'Collect numbers & operators...' : equation,
      20,
      92,
      20,
      equation.isEmpty 
          ? (settings.isDarkMode ? Colors.white38 : Colors.black38)
          : (settings.isDarkMode ? Colors.white : Colors.black87),
      FontWeight.w600,
    );
    
    // Draw hint text at bottom
    _drawText(
      canvas,
      'TAP sides • SPACE/ENTER • BACKSPACE',
      size.x / 2,
      size.y - 8,
      9,
      settings.isDarkMode ? Colors.white60 : Colors.black54,
      FontWeight.normal,
      TextAlign.center,
    );
  }
  
  int _getScore() {
    try {
      return (gameRef as dynamic).getScore();
    } catch (e) {
      return 0;
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
    Color color,
    FontWeight fontWeight, [
    TextAlign align = TextAlign.left,
  ]) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows: const [
            Shadow(
              color: Colors.black87,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
    );
    
    textPainter.layout(maxWidth: size.x - 40);
    
    double offsetX = x;
    if (align == TextAlign.center) {
      offsetX = x - textPainter.width / 2;
    }
    
    textPainter.paint(canvas, Offset(offsetX, y));
  }
}
