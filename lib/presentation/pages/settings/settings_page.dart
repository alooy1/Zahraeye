import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/game_providers.dart';
import '../../widgets/common/glass_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioSettings = ref.watch(audioSettingsProvider);
    final progress = ref.watch(playerProgressProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.galaxyGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const GlassCard(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),

              // Settings list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Audio section
                    _buildSectionTitle(context, 'Audio'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            context,
                            'Music',
                            Icons.music_note,
                            audioSettings.musicEnabled,
                            (value) {
                              ref
                                  .read(audioSettingsProvider.notifier)
                                  .toggleMusic();
                            },
                          ),
                          const Divider(color: AppColors.glassBorder),
                          _buildSwitchTile(
                            context,
                            'Sound Effects',
                            Icons.volume_up,
                            audioSettings.sfxEnabled,
                            (value) {
                              ref
                                  .read(audioSettingsProvider.notifier)
                                  .toggleSfx();
                            },
                          ),
                          const Divider(color: AppColors.glassBorder),
                          // Music Volume Slider
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.volume_down, color: Colors.white70, size: 20),
                                Expanded(
                                  child: Slider(
                                    value: audioSettings.musicVolume,
                                    min: 0.0,
                                    max: 1.0,
                                    activeColor: AppColors.starGold,
                                    inactiveColor: Colors.white24,
                                    onChanged: (value) {
                                      ref.read(audioSettingsProvider.notifier).setMusicVolume(value);
                                    },
                                  ),
                                ),
                                const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                              ],
                            ),
                          ),
                          // SFX Volume Slider
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.volume_down, color: Colors.white70, size: 20),
                                Expanded(
                                  child: Slider(
                                    value: audioSettings.sfxVolume,
                                    min: 0.0,
                                    max: 1.0,
                                    activeColor: AppColors.glowBlue,
                                    inactiveColor: Colors.white24,
                                    onChanged: (value) {
                                      ref.read(audioSettingsProvider.notifier).setSfxVolume(value);
                                    },
                                  ),
                                ),
                                const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Progress section
                    _buildSectionTitle(context, 'Progress'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Column(
                        children: [
                          _buildInfoTile(
                            context,
                            'Total Stars',
                            Icons.star,
                            '${progress.getTotalStars()}',
                            AppColors.starGold,
                          ),
                          const Divider(color: AppColors.glassBorder),
                          _buildInfoTile(
                            context,
                            'Total Coins',
                            Icons.monetization_on,
                            '${progress.totalCoins}',
                            AppColors.glowBlue,
                          ),
                          const Divider(color: AppColors.glassBorder),
                          _buildInfoTile(
                            context,
                            'Completed Stages',
                            Icons.check_circle,
                            '${progress.getTotalCompletedStages()}',
                            AppColors.success,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // About section
                    _buildSectionTitle(context, 'About'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Column(
                        children: [
                          _buildInfoTile(
                            context,
                            'Version',
                            Icons.info_outline,
                            '1.0.0',
                            Colors.white70,
                          ),
                          const Divider(color: AppColors.glassBorder),
                          ListTile(
                            leading: const Icon(
                              Icons.privacy_tip_outlined,
                              color: Colors.white70,
                            ),
                            title: Text(
                              'Privacy Policy',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.white54,
                            ),
                            onTap: () {
                              // Open privacy policy
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Reset progress
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _showResetConfirmation(context, ref),
                        icon: const Icon(
                          Icons.refresh,
                          color: AppColors.error,
                        ),
                        label: const Text(
                          'Reset Progress',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.glowBlue,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryPurple,
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    IconData icon,
    String value,
    Color valueColor,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: valueColor,
            ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.galaxyPurple.withOpacity(0.95),
        title: const Text('Reset Progress?'),
        content: const Text(
          'This will delete all your progress, stars, and coins. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(playerProgressProvider.notifier).resetProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress reset successfully')),
              );
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
