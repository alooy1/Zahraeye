import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/player_progress_repository.dart';
import '../../data/datasources/local/question_datasource.dart';
import '../../domain/entities/player_progress.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/holy_location.dart';

// Player Progress Provider
final playerProgressProvider =
    StateNotifierProvider<PlayerProgressNotifier, PlayerProgress>((ref) {
  return PlayerProgressNotifier();
});

class PlayerProgressNotifier extends StateNotifier<PlayerProgress> {
  final PlayerProgressRepository _repository = PlayerProgressRepository();

  PlayerProgressNotifier() : super(PlayerProgress.initial()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    state = await _repository.loadProgress();
  }

  Future<void> completeStage(String locationId, int stageId, int stars) async {
    await _repository.completeStage(locationId, stageId, stars);
    await _loadProgress();
  }

  bool isStageCompleted(String locationId, int stageId) {
    return state.isStageCompleted(locationId, stageId);
  }

  bool isLocationUnlocked(int locationId) {
    return state.isLocationUnlocked(locationId);
  }

  int getUnlockedStageCount(String locationId) {
    return state.getUnlockedStageCount(locationId);
  }

  bool isStageUnlocked(String locationId, int stageId) {
    if (stageId == 1) return true;
    return isStageCompleted(locationId, stageId - 1);
  }

  Future<void> resetProgress() async {
    state = await _repository.resetProgress();
  }
}

// Question Provider
final questionProvider =
    FutureProvider.family<Question?, String>((ref, locationId) async {
  final progress = ref.watch(playerProgressProvider);
  final stageId = progress.getUnlockedStageCount(locationId);
  return QuestionDataSource.getQuestion(locationId, stageId);
});

// Current Stage Question Provider
final currentQuestionProvider =
    FutureProvider.family<Question?, ({String locationId, int stageId})>(
        (ref, params) async {
  return QuestionDataSource.getQuestion(params.locationId, params.stageId);
});

// Holy Locations Provider
final holyLocationsProvider = Provider<List<HolyLocation>>((ref) {
  final progress = ref.watch(playerProgressProvider);
  final locations = HolyLocationData.getAllLocations();

  return locations.map((location) {
    final isUnlocked = progress.isLocationUnlocked(location.id);
    final unlockedStageCount = progress.getUnlockedStageCount(location.id.toString());

    return location.copyWith(
      isUnlocked: isUnlocked,
      unlockedStageCount: unlockedStageCount.clamp(1, location.totalStages),
    );
  }).toList();
});

// Audio Settings Provider
final audioSettingsProvider =
    StateNotifierProvider<AudioSettingsNotifier, AudioSettings>((ref) {
  return AudioSettingsNotifier();
});

class AudioSettings {
  final bool musicEnabled;
  final bool sfxEnabled;
  final double musicVolume;
  final double sfxVolume;

  const AudioSettings({
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.musicVolume = 0.7,
    this.sfxVolume = 0.8,
  });

  AudioSettings copyWith({
    bool? musicEnabled,
    bool? sfxEnabled,
    double? musicVolume,
    double? sfxVolume,
  }) {
    return AudioSettings(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
    );
  }
}

class AudioSettingsNotifier extends StateNotifier<AudioSettings> {
  AudioSettingsNotifier() : super(const AudioSettings());

  void toggleMusic() {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
  }

  void toggleSfx() {
    state = state.copyWith(sfxEnabled: !state.sfxEnabled);
  }

  void setMusicVolume(double volume) {
    state = state.copyWith(musicVolume: volume.clamp(0.0, 1.0));
  }

  void setSfxVolume(double volume) {
    state = state.copyWith(sfxVolume: volume.clamp(0.0, 1.0));
  }
}