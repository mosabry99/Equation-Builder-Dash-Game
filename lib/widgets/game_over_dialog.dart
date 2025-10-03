import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  final bool isDarkMode;

  const GameOverDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onRestart,
    required this.onQuit,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1a1f3a),
                    const Color(0xFF2a1f4a),
                  ]
                : [
                    const Color(0xFFe3f2fd),
                    const Color(0xFFbbdefb),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFFff6b6b).withValues(alpha: 0.5)
                : const Color(0xFFef5350).withValues(alpha: 0.5),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode
                      ? const Color(0xFFff6b6b)
                      : const Color(0xFFef5350))
                  .withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDarkMode
                        ? const Color(0xFFff6b6b)
                        : const Color(0xFFef5350))
                    .withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: isDarkMode
                    ? const Color(0xFFff6b6b)
                    : const Color(0xFFef5350),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                // Quit button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onQuit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? const Color(0xFF1a1f3a)
                          : Colors.white,
                      foregroundColor: isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.white30
                              : Colors.black26,
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text(
                      'QUIT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Restart button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRestart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? const Color(0xFF00ffff)
                          : const Color(0xFF1976d2),
                      foregroundColor: isDarkMode
                          ? const Color(0xFF0a0e27)
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'RESTART',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
