import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class StageNodeWidget extends StatefulWidget {
  final int stageId;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;
  final Color themeColor;
  final VoidCallback? onTap;

  const StageNodeWidget({
    super.key,
    required this.stageId,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.stars = 0,
    required this.themeColor,
    this.onTap,
  });

  @override
  State<StageNodeWidget> createState() => _StageNodeWidgetState();
}

class _StageNodeWidgetState extends State<StageNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isUnlocked && !widget.isCompleted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isUnlocked ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Node circle
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getBackgroundColor(),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: 2,
                  ),
                  boxShadow: widget.isUnlocked && !widget.isCompleted
                      ? [
                          BoxShadow(
                            color: widget.themeColor.withOpacity(0.4 * _pulseController.value + 0.2),
                            blurRadius: 15 * _pulseController.value + 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: _buildNodeContent(),
                ),
              ),

              const SizedBox(height: 4),

              // Stage number
              Text(
                '${widget.stageId}',
                style: TextStyle(
                  color: widget.isUnlocked ? Colors.white : Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Stars (if completed)
              if (widget.isCompleted)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Icon(
                      index < widget.stars ? Icons.star : Icons.star_border,
                      color: AppColors.starGold,
                      size: 10,
                    );
                  }),
                ),
            ],
          );
        },
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!widget.isUnlocked) {
      return Colors.grey.shade900;
    }
    if (widget.isCompleted) {
      return widget.themeColor.withOpacity(0.3);
    }
    return AppColors.galaxyPurple;
  }

  Color _getBorderColor() {
    if (!widget.isUnlocked) {
      return Colors.grey.shade700;
    }
    if (widget.isCompleted) {
      return widget.themeColor;
    }
    return widget.themeColor.withOpacity(0.6);
  }

  Widget _buildNodeContent() {
    if (!widget.isUnlocked) {
      return const Icon(
        Icons.lock,
        color: Colors.grey,
        size: 20,
      );
    }
    if (widget.isCompleted) {
      return Icon(
        Icons.check,
        color: widget.themeColor,
        size: 24,
      );
    }
    return Text(
      '${widget.stageId}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}