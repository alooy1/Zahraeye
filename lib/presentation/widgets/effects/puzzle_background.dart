import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/holy_location.dart';

class PuzzleBackground extends StatefulWidget {
  final HolyLocation location;

  const PuzzleBackground({
    super.key,
    required this.location,
  });

  @override
  State<PuzzleBackground> createState() => _PuzzleBackgroundState();
}

class _PuzzleBackgroundState extends State<PuzzleBackground>
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
          painter: PuzzleBackgroundPainter(
            animationValue: _controller.value,
            location: widget.location,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class PuzzleBackgroundPainter extends CustomPainter {
  final double animationValue;
  final HolyLocation location;

  PuzzleBackgroundPainter({
    required this.animationValue,
    required this.location,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          location.themeColor.withOpacity(0.2),
          AppColors.galaxyDark,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width,
      ));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Floating particles
    _drawFloatingParticles(canvas, size);

    // Subtle geometric patterns
    _drawGeometricPattern(canvas, size);
  }

  void _drawFloatingParticles(Canvas canvas, Size size) {
    final random = Random(location.id + 100);
    final particlePaint = Paint();

    for (int i = 0; i < 40; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final x = baseX + sin(animationValue * 2 * pi + i * 0.5) * 30;
      final y = baseY + cos(animationValue * 2 * pi + i * 0.3) * 20;
      final radius = (i % 4 + 1) * 0.8;

      particlePaint.color = (i % 2 == 0
              ? location.themeColor
              : location.secondaryColor)
          .withOpacity(0.3 + random.nextDouble() * 0.3);

      canvas.drawCircle(Offset(x, y), radius, particlePaint);
    }
  }

  void _drawGeometricPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw subtle concentric circles
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 1; i <= 5; i++) {
      final radius = (size.width * 0.15 * i) + sin(animationValue * pi) * 20;
      canvas.drawCircle(center, radius, paint);
    }

    // Draw subtle grid
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint..color = Colors.white.withOpacity(0.02),
      );
    }
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PuzzleBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}