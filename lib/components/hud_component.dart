import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../managers/equation_manager.dart';

class HudComponent extends PositionComponent with HasGameRef {
  final EquationManager equationManager;
  final VoidCallback onSubmit;
  
  final Paint glassPaint = Paint()
    ..color = const Color(0xFF1a1f3a).withOpacity(0.85)
    ..style = PaintingStyle.fill;
    
  final Paint borderPaint = Paint()
    ..color = const Color(0xFF00ffff).withOpacity(0.5)
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
    
    // Draw glassmorphism background
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(15),
    );
    
    canvas.drawRRect(rrect, glassPaint);
    canvas.drawRRect(rrect, borderPaint);
    
    // Draw level
    _drawText(
      canvas,
      'LEVEL ${equationManager.getLevel()}',
      20,
      15,
      18,
      const Color(0xFFffd93d),
      FontWeight.bold,
    );
    
    // Draw target
    _drawText(
      canvas,
      'TARGET: ${equationManager.getTarget()}',
      20,
      45,
      24,
      const Color(0xFF00ffff),
      FontWeight.bold,
    );
    
    // Draw current equation
    final equation = equationManager.getEquationString();
    _drawText(
      canvas,
      equation.isEmpty ? '...' : equation,
      20,
      80,
      20,
      Colors.white,
      FontWeight.normal,
    );
    
    // Draw hint text
    _drawText(
      canvas,
      'SPACE/ENTER to submit • BACKSPACE to undo',
      size.x / 2,
      size.y - 10,
      10,
      Colors.white60,
      FontWeight.normal,
      TextAlign.center,
    );
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
