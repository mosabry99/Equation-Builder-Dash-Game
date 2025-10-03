import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0a0e27),
              Color(0xFF1a1f3a),
              Color(0xFF2a1f4a),
              Color(0xFF3a2f5a),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            ...List.generate(20, (index) => _buildParticle(index)),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated logo
                      AnimatedBuilder(
                        animation: _rotateController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotateController.value * 2 * math.pi,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00ffff),
                                    Color(0xFF6c5ce7),
                                    Color(0xFFffd93d),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF00ffff).withValues(alpha: 0.5),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.calculate_rounded,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Game title
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF00ffff),
                            Color(0xFFffd93d),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'EQUATION',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),

                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFffd93d),
                            Color(0xFFff6b6b),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'BUILDER DASH',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(2, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tagline
                      const Text(
                        'Math • Reflex • Arcade',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Loading indicator
                      SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF00ffff),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    final duration = random.nextInt(3) + 2;

    return Positioned(
      left: left,
      top: top,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(seconds: duration),
        builder: (context, value, child) {
          return Opacity(
            opacity: (math.sin(value * math.pi * 2) + 1) / 2,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: [
                  Color(0xFF00ffff),
                  Color(0xFFffd93d),
                  Color(0xFFff6b6b),
                  Color(0xFF6c5ce7),
                ][index % 4],
                boxShadow: [
                  BoxShadow(
                    color: [
                      Color(0xFF00ffff),
                      Color(0xFFffd93d),
                      Color(0xFFff6b6b),
                      Color(0xFF6c5ce7),
                    ][index % 4]
                        .withValues(alpha: 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
