import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_constants.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showLogo = false;
  bool _showParticles = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _showParticles = true);
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _showLogo = true);
      _controller.forward();
    }
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      context.go('/world-map');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.galaxyGradient,
        ),
        child: Stack(
          children: [
            // Starfield background
            const StarFieldBackground(),

            // Galaxy particles
            if (_showParticles) const GalaxyParticles(),

            // Logo and text
            if (_showLogo)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo glow effect
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.5),
                            blurRadius: 50,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: Text(
                        'ZAHRA',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              color: AppColors.glowPurple,
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(controller: _controller)
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'EYE',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 48,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 16,
                                color: AppColors.glowBlue,
                              ),
                    )
                        .animate(controller: _controller)
                        .fadeIn(duration: 800.ms, delay: 200.ms)
                        .slideY(begin: 0.3, end: 0),
                    const SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                        children: const [
                          TextSpan(
                            text: 'عين ',
                            style: TextStyle(
                              color: AppColors.glowBlue,
                              shadows: [
                                Shadow(
                                  color: AppColors.glowBlue,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          TextSpan(
                            text: 'الزهراء',
                            style: TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: AppColors.primaryPurple,
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate(controller: _controller)
                        .fadeIn(duration: 800.ms, delay: 400.ms),
                  ],
                ),
              ),

            // Loading indicator
            if (_showLogo)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: AppColors.glassWhite,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.glowBlue.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StarFieldBackground extends StatelessWidget {
  const StarFieldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarFieldPainter(),
      size: Size.infinite,
    );
  }
}

class StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    // Generate stars using fixed pattern
    for (int i = 0; i < 150; i++) {
      final x = (i * 137.5) % size.width;
      final y = (i * 97.3) % size.height;
      final radius = ((i % 3) + 1) * 0.5;
      final opacity = ((i % 10) + 3) / 13;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GalaxyParticles extends StatefulWidget {
  const GalaxyParticles({super.key});

  @override
  State<GalaxyParticles> createState() => _GalaxyParticlesState();
}

class _GalaxyParticlesState extends State<GalaxyParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GalaxyParticlesPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class GalaxyParticlesPainter extends CustomPainter {
  final double animationValue;

  GalaxyParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw nebula-like particles
    for (int i = 0; i < 30; i++) {
      final x = size.width * (0.1 + 0.8 * ((i * 0.1 + animationValue) % 1));
      final y =
          size.height * (0.1 + 0.8 * ((i * 0.15 + animationValue * 0.5) % 1));

      final colors = [
        AppColors.nebulaPink,
        AppColors.primaryPurple,
        AppColors.glowBlue,
        AppColors.glowPurple,
      ];

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i % colors.length].withOpacity(0.6),
            colors[i % colors.length].withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(x, y),
          radius: 80,
        ));

      canvas.drawCircle(Offset(x, y), 80, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GalaxyParticlesPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
