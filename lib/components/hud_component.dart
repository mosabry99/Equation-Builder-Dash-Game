import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../managers/equation_manager.dart';
import '../managers/settings_manager.dart';
import '../managers/theme_manager.dart';

class HudComponent extends PositionComponent with HasGameReference {
  final EquationManager equationManager;
  final VoidCallback onSubmit;
  final SettingsManager settings = SettingsManager();
  late GameTheme theme;

  HudComponent({
    required this.equationManager,
    required this.onSubmit,
  }) : super(
          priority: 100,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    theme = GameTheme(isDark: settings.isDarkMode);
    position = Vector2(15, 35);
    size = Vector2(game.size.x - 30, 160); // Increased height for better spacing
  }

  void updateDisplay() {
    theme = GameTheme(isDark: settings.isDarkMode);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Update theme
    theme = GameTheme(isDark: settings.isDarkMode);
    
    // Draw glassmorphism background with enhanced glow
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(20),
    );
    
    // Draw outer glow
    final glowPaint = Paint()
      ..color = theme.hudGlow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawRRect(rrect, glowPaint);
    
    // Draw background
    final glassPaint = Paint()
      ..color = theme.hudBackground
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, glassPaint);
    
    // Draw border
    final borderPaint = Paint()
      ..color = theme.hudBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);
    
    // ROW 1: Level (left) | Score (center) | Target (right)
    // Level on the left
    _drawText(
      canvas,
      'LV ${equationManager.getLevel()}',
      15,
      12,
      16,
      theme.tertiaryAccent,
      FontWeight.bold,
    );
    
    // Score in the center
    final scoreText = '${_getScore()}pts';
    final scoreTextPainter = TextPainter(
      text: TextSpan(
        text: scoreText,
        style: TextStyle(
          color: theme.successColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              color: Colors.black45,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    scoreTextPainter.layout();
    scoreTextPainter.paint(
      canvas,
      Offset((size.x - scoreTextPainter.width) / 2, 10),
    );
    
    // Target on the right
    final targetText = '🎯 ${equationManager.getTarget()}';
    final targetTextPainter = TextPainter(
      text: TextSpan(
        text: targetText,
        style: TextStyle(
          color: theme.primaryAccent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              color: Colors.black45,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    targetTextPainter.layout();
    targetTextPainter.paint(
      canvas,
      Offset(size.x - targetTextPainter.width - 15, 10),
    );
    
    // Divider line
    final dividerPaint = Paint()
      ..color = theme.hudBorder
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(15, 42),
      Offset(size.x - 15, 42),
      dividerPaint,
    );
    
    // ROW 2: Current equation with label
    _drawText(
      canvas,
      'EQUATION:',
      15,
      50,
      12,
      theme.textSecondary,
      FontWeight.w600,
    );
    
    // Draw current equation with box
    final equation = equationManager.getEquationString();
    final equationRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(15, 70, size.x - 30, 40),
      const Radius.circular(12),
    );
    
    final equationBoxPaint = Paint()
      ..color = theme.cardBackground.withValues(alpha: 0.3);
    canvas.drawRRect(equationRect, equationBoxPaint);
    
    // Border for equation box
    final equationBorderPaint = Paint()
      ..color = theme.cardBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(equationRect, equationBorderPaint);
    
    _drawText(
      canvas,
      equation.isEmpty ? 'Start collecting...' : equation,
      22,
      80,
      22,
      equation.isEmpty 
          ? theme.textTertiary
          : theme.textPrimary,
      FontWeight.w600,
    );
    
    // ROW 3: Hint text at bottom
    _drawText(
      canvas,
      '← TAP SIDES → • SPACE/ENTER • BACKSPACE',
      size.x / 2,
      size.y - 22,
      10,
      theme.textSecondary,
      FontWeight.w500,
      TextAlign.center,
    );
  }
  
  int _getScore() {
    try {
      return (game as dynamic).getScore();
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
