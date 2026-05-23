import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class GalaxyBackground extends StatefulWidget {
  const GalaxyBackground({super.key});

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
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
          painter: GalaxyBackgroundPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class GalaxyBackgroundPainter extends CustomPainter {
  final double animationValue;

  GalaxyBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Background gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppColors.galaxyDark,
          AppColors.galaxyPurple,
          AppColors.primaryPurple,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw stars
    _drawStars(canvas, size);

    // Draw nebula clouds
    _drawNebula(canvas, size);

    // Draw energy lines
    _drawEnergyLines(canvas, size);
  }

  void _drawStars(Canvas canvas, Size size) {
    final random = Random(42);
    final starPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 200; i++) {
      final x = (random.nextDouble() * size.width + animationValue * 50) % size.width;
      final y = (random.nextDouble() * size.height + animationValue * 30) % size.height;
      final radius = random.nextDouble() * 2 + 0.5;
      final brightness = random.nextDouble() * 0.5 + 0.5;

      // Twinkle effect
      final twinkle = sin(animationValue * 2 * pi + i) * 0.3 + 0.7;

      starPaint.color = Colors.white.withOpacity(brightness * twinkle);

      // Glow effect for some stars
      if (i % 10 == 0) {
        final glowPaint = Paint()
          ..color = AppColors.glowBlue.withOpacity(0.3 * twinkle)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
        canvas.drawCircle(Offset(x, y), radius * 3, glowPaint);
      }

      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  void _drawNebula(Canvas canvas, Size size) {
    final nebulaPositions = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.8),
    ];

    final nebulaColors = [
      AppColors.nebulaPink.withOpacity(0.15),
      AppColors.primaryPurple.withOpacity(0.15),
      AppColors.glowBlue.withOpacity(0.1),
    ];

    for (int i = 0; i < nebulaPositions.length; i++) {
      final pos = nebulaPositions[i];
      final color = nebulaColors[i];

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color,
            color.withOpacity(0),
          ],
        ).createShader(Rect.fromCircle(center: pos, radius: 200));

      // Animate position slightly
      final animatedX = pos.dx + sin(animationValue * pi + i) * 30;
      final animatedY = pos.dy + cos(animationValue * pi + i) * 20;

      canvas.drawCircle(Offset(animatedX, animatedY), 200, paint);
    }
  }

  void _drawEnergyLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.glowPurple.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw some subtle energy lines
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startX = (i * size.width / 5 + animationValue * 50) % size.width;
      path.moveTo(startX, 0);

      for (double y = 0; y < size.height; y += 20) {
        final x = startX + sin(y * 0.02 + animationValue * pi) * 30;
        path.lineTo(x, y);
      }

      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant GalaxyBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}