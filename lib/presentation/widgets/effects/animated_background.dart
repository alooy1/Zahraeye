import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/holy_location.dart';

class AnimatedBackground extends StatefulWidget {
  final HolyLocation location;

  const AnimatedBackground({
    super.key,
    required this.location,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
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
          painter: LocationBackgroundPainter(
            animationValue: _controller.value,
            location: widget.location,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class LocationBackgroundPainter extends CustomPainter {
  final double animationValue;
  final HolyLocation location;

  LocationBackgroundPainter({
    required this.animationValue,
    required this.location,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          location.secondaryColor.withOpacity(0.3),
          location.themeColor.withOpacity(0.2),
          AppColors.galaxyDark,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw animated particles based on location theme
    _drawParticles(canvas, size);

    // Draw subtle light rays
    _drawLightRays(canvas, size);
  }

  void _drawParticles(Canvas canvas, Size size) {
    final random = Random(location.id);
    final particlePaint = Paint()
      ..color = location.themeColor.withOpacity(0.6);

    for (int i = 0; i < 30; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final x = baseX + sin(animationValue * 2 * pi + i) * 20;
      final y = baseY + cos(animationValue * 2 * pi + i) * 15;
      final radius = (i % 3 + 1) * 1.5;

      // Glow effect
      final glowPaint = Paint()
        ..color = location.themeColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(x, y), radius * 2, glowPaint);

      canvas.drawCircle(Offset(x, y), radius, particlePaint);
    }
  }

  void _drawLightRays(Canvas canvas, Size size) {
    final rayPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          location.themeColor.withOpacity(0.1),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int i = 0; i < 3; i++) {
      final x = size.width * (0.3 + i * 0.2);
      final path = Path();
      path.moveTo(x - 50, 0);
      path.lineTo(x + 50, 0);
      path.lineTo(x + 100, size.height);
      path.lineTo(x - 100, size.height);
      path.close();

      canvas.drawPath(path, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant LocationBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}