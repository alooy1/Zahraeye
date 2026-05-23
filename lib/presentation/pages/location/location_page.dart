import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/game_providers.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/game/stage_node.dart';
import '../../widgets/effects/animated_background.dart';

class LocationPage extends ConsumerWidget {
  final int locationId;

  const LocationPage({
    super.key,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(holyLocationsProvider);
    final location = locations.firstWhere(
      (l) => l.id == locationId,
      orElse: () => locations.first,
    );
    final progress = ref.watch(playerProgressProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Animated location background
          AnimatedBackground(location: location),

          // Top bar - pushed down with SizedBox
          Column(
            children: [
              const SizedBox(height: 60),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const GlassCard(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Location title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.nameEn,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              location.nameAr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: location.themeColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Progress indicator
                      GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${progress.getUnlockedStageCount(locationId.toString())}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: location.themeColor,
                                  ),
                            ),
                            Text(
                              '/12',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white54,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Stage nodes grid
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 200, 16, 40),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: location.totalStages,
              itemBuilder: (context, index) {
                final stageId = index + 1;
                final isUnlocked =
                    progress.isStageUnlocked(locationId.toString(), stageId);
                final isCompleted =
                    progress.isStageCompleted(locationId.toString(), stageId);
                final stars = isCompleted ? 3 : 0;

                return StageNodeWidget(
                  stageId: stageId,
                  isUnlocked: isUnlocked,
                  isCompleted: isCompleted,
                  stars: stars,
                  themeColor: location.themeColor,
                  onTap: () {
                    if (isUnlocked) {
                      context.push('/puzzle/$locationId/$stageId');
                    }
                  },
                )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: index * 50))
                    .scale(begin: const Offset(0.8, 0.8));
              },
            ),
          ),

          // Bottom progress bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.galaxyDark,
                    AppColors.galaxyDark.withOpacity( 0),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${(progress.getUnlockedStageCount(locationId.toString()) / 12 * 100).toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: location.themeColor,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress.getUnlockedStageCount(
                                  locationId.toString()) /
                              12,
                          backgroundColor: AppColors.glassWhite,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              location.themeColor),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
