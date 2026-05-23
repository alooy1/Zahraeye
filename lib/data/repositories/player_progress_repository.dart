import 'dart:convert';
import '../../domain/entities/player_progress.dart';
import '../datasources/local/hive_init.dart';

class PlayerProgressRepository {
  static const String _progressKey = 'player_progress';

  Future<PlayerProgress> loadProgress() async {
    try {
      final box = HiveInit.playerProgressBoxInstance;
      final jsonString = box.get(_progressKey) as String?;
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return PlayerProgress.fromJson(json);
      }
      return PlayerProgress.initial();
    } catch (e) {
      return PlayerProgress.initial();
    }
  }

  Future<void> saveProgress(PlayerProgress progress) async {
    try {
      final box = HiveInit.playerProgressBoxInstance;
      final jsonString = jsonEncode(progress.toJson());
      await box.put(_progressKey, jsonString);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> completeStage(String locationId, int stageId, int stars) async {
    final progress = await loadProgress();

    // Add completed stage
    final completedStages = Map<String, List<int>>.from(progress.completedStages);
    if (!completedStages.containsKey(locationId)) {
      completedStages[locationId] = [];
    }
    if (!completedStages[locationId]!.contains(stageId)) {
      completedStages[locationId]!.add(stageId);
    }

    // Update stars
    final starsPerLocation = Map<String, int>.from(progress.starsPerLocation);
    final currentStars = starsPerLocation[locationId] ?? 0;
    starsPerLocation[locationId] = currentStars + stars;

    // Calculate coins reward
    final coinsReward = stars * 50;

    final newProgress = progress.copyWith(
      completedStages: completedStages,
      starsPerLocation: starsPerLocation,
      totalCoins: progress.totalCoins + coinsReward,
      lastPlayed: DateTime.now(),
    );

    await saveProgress(newProgress);
  }

  Future<PlayerProgress> resetProgress() async {
    final progress = PlayerProgress.initial();
    await saveProgress(progress);
    return progress;
  }
}