import 'package:flutter/material.dart';
import '../managers/settings_manager.dart';
import 'settings_screen.dart';
import '../main.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  final SettingsManager _settings = SettingsManager();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _settings.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0a0e27),
                    const Color(0xFF1a1f3a),
                    const Color(0xFF2a1f4a),
                  ]
                : [
                    const Color(0xFFe3f2fd),
                    const Color(0xFFbbdefb),
                    const Color(0xFF90caf9),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Game Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (isDark
                                ? const Color(0xFF00ffff)
                                : const Color(0xFF1976d2))
                            .withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark
                                    ? const Color(0xFF00ffff)
                                    : const Color(0xFF1976d2))
                                .withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.calculate_rounded,
                        size: 80,
                        color: isDark
                            ? const Color(0xFF00ffff)
                            : const Color(0xFF1976d2),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      'Equation Builder',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: (isDark
                                    ? const Color(0xFF00ffff)
                                    : const Color(0xFF1976d2))
                                .withValues(alpha: 0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Dash Game',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: isDark ? Colors.white70 : Colors.black54,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Start Play Button
                    _buildMenuButton(
                      context: context,
                      label: 'START PLAY',
                      icon: Icons.play_arrow_rounded,
                      isPrimary: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Settings Button
                    _buildMenuButton(
                      context: context,
                      label: 'SETTINGS',
                      icon: Icons.settings,
                      isPrimary: false,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                        setState(() {
                          // Refresh UI after settings change
                        });
                      },
                    ),

                    const SizedBox(height: 60),

                    // Footer
                    Text(
                      'Collect numbers to reach the target!',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black45,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    final isDark = _settings.isDarkMode;

    return Container(
      width: 280,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: isPrimary
            ? LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF00ffff),
                        const Color(0xFF00d4d4),
                      ]
                    : [
                        const Color(0xFF1976d2),
                        const Color(0xFF1565c0),
                      ],
              )
            : null,
        color: isPrimary
            ? null
            : (isDark ? const Color(0xFF1a1f3a) : Colors.white),
        border: Border.all(
          color: isPrimary
              ? Colors.transparent
              : (isDark
                  ? const Color(0xFF00ffff).withValues(alpha: 0.5)
                  : const Color(0xFF1976d2).withValues(alpha: 0.5)),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPrimary
                    ? (isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2))
                    : (isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2)))
                .withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: isPrimary ? 2 : 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(35),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isPrimary
                      ? (isDark ? const Color(0xFF0a0e27) : Colors.white)
                      : (isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2)),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: isPrimary
                        ? (isDark ? const Color(0xFF0a0e27) : Colors.white)
                        : (isDark ? const Color(0xFF00ffff) : const Color(0xFF1976d2)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
