import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class RotateWheelPuzzle extends StatefulWidget {
  final String answer;
  final ValueChanged<String> onAnswerChanged;
  final Color themeColor;

  const RotateWheelPuzzle({
    super.key,
    required this.answer,
    required this.onAnswerChanged,
    required this.themeColor,
  });

  @override
  State<RotateWheelPuzzle> createState() => _RotateWheelPuzzleState();
}

class _RotateWheelPuzzleState extends State<RotateWheelPuzzle> {
  final List<double> _rotations = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Initialize with random rotations
    for (int i = 0; i < widget.answer.length; i++) {
      _rotations.add(_random.nextDouble() * 6.28); // Random 0-2π
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Instructions
        Text(
          'Rotate rings to align letters',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),

        const SizedBox(height: 24),

        // Answer display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.answer.length, (index) {
              return _buildRotatedLetter(widget.answer[index].toUpperCase(), index);
            }),
          ),
        ),

        const SizedBox(height: 40),

        // Rotating wheels
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.answer.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _rotations[index] += details.delta.dx * 0.05;
                  });
                  _checkAlignment();
                },
                onTap: () {
                  // Snap to nearest correct rotation
                  _snapToLetter(index, widget.answer[index].toUpperCase());
                },
                child: _buildWheel(index),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        // Reset button
        TextButton.icon(
          onPressed: _resetWheels,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
      ],
    );
  }

  Widget _buildRotatedLetter(String letter, int index) {
    // Check if the wheel is aligned
    final rotation = _rotations[index];
    final isAligned = (rotation.abs() % (2 * pi)) < 0.5 ||
        (rotation.abs() % (2 * pi)) > (2 * pi - 0.5);

    return Container(
      width: 40,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isAligned
            ? AppColors.success.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAligned ? AppColors.success : Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Transform.rotate(
          angle: _rotations[index],
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWheel(int index) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  widget.themeColor.withOpacity(0.3),
                  widget.themeColor.withOpacity(0.6),
                  widget.themeColor.withOpacity(0.3),
                ],
              ),
              border: Border.all(
                color: widget.themeColor,
                width: 3,
              ),
            ),
          ),

          // Letters around the ring
          ...List.generate(6, (i) {
            final angle = (i * pi / 3) + _rotations[index];
            final x = 30 * cos(angle);
            final y = 30 * sin(angle);
            final letterIndex = (index + i) % widget.answer.length;
            final letter = widget.answer[letterIndex].toUpperCase();

            return Transform.translate(
              offset: Offset(x, y),
              child: Text(
                letter,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),

          // Center knob
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.themeColor,
              boxShadow: [
                BoxShadow(
                  color: widget.themeColor.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _snapToLetter(int index, String targetLetter) {
    // Calculate the rotation needed to align with target letter
    // This is a simplified version - in production, you'd calculate the exact angle
    setState(() {
      // Snap to nearest upright position
      final current = _rotations[index];
      final snapped = (current / (pi / 3)).round() * (pi / 3);
      _rotations[index] = snapped;
    });
    _checkAlignment();
  }

  void _resetWheels() {
    setState(() {
      for (int i = 0; i < _rotations.length; i++) {
        _rotations[i] = _random.nextDouble() * 6.28;
      }
    });
  }

  void _checkAlignment() {
    // Build current answer
    final answer = StringBuffer();
    for (int i = 0; i < widget.answer.length; i++) {
      final rotation = _rotations[i];
      // Normalize rotation to 0-2π
      final normalized = rotation.abs() % (2 * pi);
      // Each letter occupies π/3 (60 degrees)
      final position = (normalized / (pi / 3)).round() % 6;
      final letterIndex = (i + position) % widget.answer.length;
      answer.write(widget.answer[letterIndex].toUpperCase());
    }
    widget.onAnswerChanged(answer.toString());
  }
}