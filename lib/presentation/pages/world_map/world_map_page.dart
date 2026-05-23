import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/datasources/local/audio_manager.dart';
import '../../../domain/entities/holy_location.dart';
import '../../../domain/entities/player_progress.dart';
import '../../providers/game_providers.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/game/galaxy_background.dart';
import '../../widgets/game/location_node.dart';

class WorldMapPage extends ConsumerStatefulWidget {
  const WorldMapPage({super.key});

  @override
  ConsumerState<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends ConsumerState<WorldMapPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late TransformationController _transformationController;
  int _centeredLocationId = 0;

  // World dimensions
  static const double _worldWidth = 2600.0;
  static const double _worldHeight = 2600.0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _transformationController = TransformationController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioManagerProvider).playMusic('main_theme');
      _centerOnCurrentLocation();
      _transformationController.addListener(_onMapTransform);
    });
  }

  void _onMapTransform() {
    if (!mounted) return;

    final matrix = _transformationController.value;
    final scale = matrix.getMaxScaleOnAxis();

    if (scale < 0.1) return;

    final tx = matrix.getTranslation().x;
    final ty = matrix.getTranslation().y;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final centerX = -tx + screenWidth / 2;
    final centerY = -ty + screenHeight / 2;

    final locations = ref.read(holyLocationsProvider);
    double minDistance = double.infinity;
    int nearestId = 0;

    for (int i = 0; i < locations.length; i++) {
      final loc = locations[i];
      final dx = loc.positionX - centerX;
      final dy = loc.positionY - centerY;
      final distanceSq = dx * dx + dy * dy;

      if (distanceSq < minDistance) {
        minDistance = distanceSq;
        nearestId = i;
      }
    }

    if (nearestId == _centeredLocationId) return;

    final threshold = 4900 * scale * scale;

    if (minDistance < threshold) {
      _centeredLocationId = nearestId;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _centerOnCurrentLocation() {
    final progress = ref.read(playerProgressProvider);
    final locations = ref.read(holyLocationsProvider);
    final currentLocationId = progress.currentLocationId;

    if (currentLocationId < locations.length) {
      final location = locations[currentLocationId];
      final screenSize = MediaQuery.of(context).size;

      final offsetX = screenSize.width / 2 - location.positionX;
      final offsetY = screenSize.height / 2 - location.positionY;

      _transformationController.value = Matrix4.identity()
        ..translate(offsetX, offsetY);
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _onLocationTap(HolyLocation location) {
    ref.read(audioManagerProvider).playClick();
    if (!location.isUnlocked) {
      _showLockedDialog(location);
      return;
    }
    context.push('/location/${location.id}');
  }

  void _showLockedDialog(HolyLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.galaxyPurple.withOpacity( 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock, color: AppColors.warning),
            SizedBox(width: 12),
            Text('Location Locked'),
          ],
        ),
        content: Text(
          'Complete all stages in ${_getPreviousLocation(location.id)?.nameEn ?? "the previous location"} to unlock this location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  HolyLocation? _getPreviousLocation(int locationId) {
    if (locationId == 0) return null;
    final locations = ref.read(holyLocationsProvider);
    return locations[locationId - 1];
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(holyLocationsProvider);
    final progress = ref.watch(playerProgressProvider);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: GalaxyBackground(),
          ),

          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.3,
            maxScale: 3.0,
            boundaryMargin: const EdgeInsets.all(100),
            constrained: false,
            child: SizedBox(
              width: _worldWidth,
              height: _worldHeight,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(_worldWidth, _worldHeight),
                    painter: LocationPathPainter(locations),
                  ),
                  ..._buildLocationNodes(locations, progress),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Row(
                children: [
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.starGold,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progress.getTotalStars()}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.monetization_on,
                          color: AppColors.glowBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progress.totalCoins}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.push('/settings'),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locations.isNotEmpty &&
                            _centeredLocationId < locations.length
                        ? locations[_centeredLocationId].nameEn
                        : 'Prophet Mosque',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locations.isNotEmpty &&
                            _centeredLocationId < locations.length
                        ? locations[_centeredLocationId].nameAr
                        : 'مسجد النبي',
                    style: const TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GlassCard(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: AppColors.glowBlue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Drag to explore • Tap to enter',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLocationNodes(
      List<HolyLocation> locations, PlayerProgress progress) {
    List<Widget> nodes = [];

    for (int i = 0; i < locations.length; i++) {
      final location = locations[i];
      nodes.add(
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final floatOffset = (i % 2 == 0)
                ? _floatController.value * 8
                : -_floatController.value * 8;

            return Positioned(
              left: location.positionX - 70,
              top: location.positionY - 70 + floatOffset,
              child: GestureDetector(
                onTap: () => _onLocationTap(location),
                child: LocationNodeWidget(
                  location: location,
                  isCompleted: progress.isLocationUnlocked(location.id),
                  progress: progress,
                ),
              ),
            );
          },
        ),
      );
    }

    return nodes;
  }
}

class LocationPathPainter extends CustomPainter {
  final List<HolyLocation> locations;

  LocationPathPainter(this.locations);

  @override
  void paint(Canvas canvas, Size size) {
    if (locations.isEmpty) return;

    final glowPaint = Paint()
      ..color = Colors.white.withOpacity( 0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final linePaint = Paint()
      ..color = Colors.white.withOpacity( 0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < locations.length - 1; i++) {
      final start = Offset(
        locations[i].positionX,
        locations[i].positionY,
      );
      final end = Offset(
        locations[i + 1].positionX,
        locations[i + 1].positionY,
      );

      double distance = (end - start).distance;
      int dashes = (distance / 20).toInt();
      if (dashes < 1) dashes = 1;

      for (int j = 0; j < dashes; j += 2) {
        final t1 = j / dashes;
        final t2 = (j + 1) / dashes;
        final p1 = Offset.lerp(start, end, t1) ?? start;
        final p2 = Offset.lerp(start, end, t2) ?? end;

        canvas.drawLine(p1, p2, glowPaint);
        canvas.drawLine(p1, p2, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}