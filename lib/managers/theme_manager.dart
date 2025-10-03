import 'package:flutter/material.dart';

/// Comprehensive theme manager for the game
/// Provides consistent colors across all components
class GameTheme {
  final bool isDark;
  
  const GameTheme({required this.isDark});
  
  // Background colors
  Color get backgroundColor => isDark 
    ? const Color(0xFF0a0e27) 
    : const Color(0xFFe3f2fd);
  
  Color get secondaryBackground => isDark
    ? const Color(0xFF1a1f3a)
    : const Color(0xFFbbdefb);
  
  Color get tertiaryBackground => isDark
    ? const Color(0xFF2a1f4a)
    : const Color(0xFF90caf9);
  
  // Primary accent colors
  Color get primaryAccent => isDark
    ? const Color(0xFF00ffff) // Cyan
    : const Color(0xFF1976d2); // Blue
  
  Color get secondaryAccent => isDark
    ? const Color(0xFF6c5ce7) // Purple
    : const Color(0xFF42a5f5); // Light blue
  
  Color get tertiaryAccent => isDark
    ? const Color(0xFFffd93d) // Gold
    : const Color(0xFFffa726); // Orange
  
  // Text colors
  Color get textPrimary => isDark
    ? Colors.white
    : Colors.black87;
  
  Color get textSecondary => isDark
    ? Colors.white70
    : Colors.black54;
  
  Color get textTertiary => isDark
    ? Colors.white38
    : Colors.black38;
  
  // Game element colors
  Color get playerColor => isDark
    ? const Color(0xFF00ffff)
    : const Color(0xFF1976d2);
  
  Color get playerGlow => isDark
    ? const Color(0xFF00ffff).withValues(alpha: 0.3)
    : const Color(0xFF1976d2).withValues(alpha: 0.3);
  
  Color get numberColor => isDark
    ? const Color(0xFF4ecdc4) // Cyan
    : const Color(0xFF26c6da); // Light cyan
  
  Color get operatorColor => isDark
    ? const Color(0xFFff6b6b) // Red
    : const Color(0xFFef5350); // Light red
  
  Color get successColor => const Color(0xFF26de81); // Green (same for both)
  
  Color get errorColor => const Color(0xFFff6b6b); // Red (same for both)
  
  Color get warningColor => isDark
    ? const Color(0xFFffd93d)
    : const Color(0xFFffa726);
  
  // HUD/UI colors
  Color get hudBackground => isDark
    ? const Color(0xFF1a1f3a).withValues(alpha: 0.9)
    : Colors.white.withValues(alpha: 0.95);
  
  Color get hudBorder => primaryAccent.withValues(alpha: 0.5);
  
  Color get hudGlow => primaryAccent.withValues(alpha: 0.15);
  
  Color get cardBackground => isDark
    ? const Color(0xFF1a1f3a).withValues(alpha: 0.9)
    : Colors.white.withValues(alpha: 0.9);
  
  Color get cardBorder => primaryAccent.withValues(alpha: 0.3);
  
  Color get cardShadow => primaryAccent.withValues(alpha: 0.2);
  
  // Button colors
  Color get buttonBackground => primaryAccent;
  
  Color get buttonText => Colors.white;
  
  // Special effects colors
  List<Color> get particleColors => isDark
    ? [
        const Color(0xFF00ffff),
        const Color(0xFFffd93d),
        const Color(0xFFff6b6b),
        const Color(0xFF6c5ce7),
      ]
    : [
        const Color(0xFF1976d2),
        const Color(0xFFffa726),
        const Color(0xFFef5350),
        const Color(0xFF42a5f5),
      ];
  
  List<Color> get confettiColors => isDark
    ? [
        const Color(0xFF00ffff),
        const Color(0xFFffd93d),
        const Color(0xFF6c5ce7),
        const Color(0xFFff6b6b),
        const Color(0xFF26de81),
        const Color(0xFFfe9c8f),
      ]
    : [
        const Color(0xFF1976d2),
        const Color(0xFFffa726),
        const Color(0xFF42a5f5),
        const Color(0xFFef5350),
        const Color(0xFF66bb6a),
        const Color(0xFFff7043),
      ];
  
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
      ? [
          const Color(0xFF0a0e27),
          const Color(0xFF1a1f3a),
          const Color(0xFF2a1f4a),
          const Color(0xFF3a2f5a),
        ]
      : [
          const Color(0xFFe3f2fd),
          const Color(0xFFbbdefb),
          const Color(0xFF90caf9),
          const Color(0xFF64b5f6),
        ],
  );
  
  BoxShadow get glowShadow => BoxShadow(
    color: primaryAccent.withValues(alpha: 0.5),
    blurRadius: 30,
    spreadRadius: 10,
  );
  
  BoxShadow get cardShadowEffect => BoxShadow(
    color: primaryAccent.withValues(alpha: 0.2),
    blurRadius: 15,
    spreadRadius: 2,
  );
}
