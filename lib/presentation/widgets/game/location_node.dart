import 'package:flutter/material.dart';

import '../../../domain/entities/holy_location.dart';

class LocationNodeWidget extends StatefulWidget {
  final HolyLocation location;
  final bool isCompleted;
  final dynamic progress;
  final VoidCallback? onTap;

  const LocationNodeWidget({
    super.key,
    required this.location,
    this.isCompleted = false,
    this.progress,
    this.onTap,
  });

  @override
  State<LocationNodeWidget> createState() => _LocationNodeWidgetState();
}

class _LocationNodeWidgetState extends State<LocationNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return SizedBox(
            width: 180 * widget.location.scale,
            height: 240 * widget.location.scale,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Glow effect - positioned above circle
                if (widget.location.isUnlocked)
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 140 * widget.location.scale * _pulseAnimation.value,
                      height: 140 * widget.location.scale * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.location.themeColor.withOpacity( 0.4),
                            blurRadius: 30 * _pulseAnimation.value,
                            spreadRadius: 10 * _pulseAnimation.value,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Main circle - at top
                Positioned(
                  top: 0,
                  child: Container(
                    width: 140 * widget.location.scale,
                    height: 140 * widget.location.scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: widget.location.isUnlocked
                            ? [
                                widget.location.themeColor,
                                widget.location.themeColor.withOpacity( 0.7),
                              ]
                            : [
                                Colors.grey.shade700,
                                Colors.grey.shade900,
                              ],
                      ),
                      border: Border.all(
                        color: widget.location.isUnlocked
                            ? Colors.white.withOpacity( 0.5)
                            : Colors.grey.shade600,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.location.isUnlocked
                              ? widget.location.themeColor.withOpacity( 0.5)
                              : Colors.black.withOpacity( 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Show image for all locations
                        _buildImage(),
                        // Show lock overlay for locked locations
                        if (!widget.location.isUnlocked)
                          Container(
                            width: 130 * widget.location.scale,
                            height: 130 * widget.location.scale,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity( 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 40 * widget.location.scale,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getLocationIcon() {
    switch (widget.location.id) {
      case 0:
        return Icons.mosque;
      case 1:
        return Icons.account_balance;
      case 2:
        return Icons.landscape;
      case 3:
        return Icons.mosque;
      case 4:
        return Icons.mosque;
      case 5:
        return Icons.mosque;
      case 6:
        return Icons.mosque;
      case 7:
        return Icons.account_balance;
      case 8:
        return Icons.account_balance;
      default:
        return Icons.place;
    }
  }

  String _getLocationImage() {
    switch (widget.location.id) {
      case 0:
        return 'assets/images/locations/imam_ali.png';
      case 1:
        return 'assets/images/locations/mohammed.png';
      case 2:
        return 'assets/images/locations/albaqea.png';
      case 3:
        return 'assets/images/locations/hussain.png';
      case 4:
        return 'assets/images/locations/alkadem.png';
      case 5:
        return 'assets/images/locations/alredah.png';
      case 6:
        return 'assets/images/locations/alaskreen.png';
      case 7:
        return 'assets/images/locations/QM.png';
      case 8:
        return 'assets/images/locations/fatima.png';
      default:
        return 'assets/images/locations/mohammed.png';
    }
  }

  Widget _buildImage() {
    final imagePath = _getLocationImage();
    final size = 130 * widget.location.scale;
    return ClipOval(
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading image: $error for $imagePath');
          return Icon(
            _getLocationIcon(),
            color: Colors.white,
            size: 40 * widget.location.scale,
          );
        },
      ),
    );
  }
}