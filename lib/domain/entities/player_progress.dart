class PlayerProgress {
  final Map<String, List<int>> completedStages; // location_id -> [stage_ids]
  final Map<String, int> starsPerLocation; // location_id -> total_stars
  final int currentLocationId;
  final int currentStageId;
  final int totalCoins;
  final DateTime lastPlayed;

  const PlayerProgress({
    this.completedStages = const {},
    this.starsPerLocation = const {},
    this.currentLocationId = 0,
    this.currentStageId = 0,
    this.totalCoins = 0,
    required this.lastPlayed,
  });

  factory PlayerProgress.initial() {
    return PlayerProgress(
      completedStages: {},
      starsPerLocation: {},
      currentLocationId: 0,
      currentStageId: 0,
      totalCoins: 0,
      lastPlayed: DateTime.now(),
    );
  }

  bool isStageCompleted(String locationId, int stageId) {
    return completedStages[locationId]?.contains(stageId) ?? false;
  }

  bool isStageUnlocked(String locationId, int stageId) {
    if (stageId == 1) return true;
    final completed = completedStages[locationId] ?? [];
    return completed.contains(stageId - 1);
  }

  bool isLocationUnlocked(int locationId) {
    // All locations are unlocked
    return true;
  }

  int getUnlockedStageCount(String locationId) {
    // All 12 stages are always unlocked
    return 12;
  }

  int getTotalCompletedStages() {
    int total = 0;
    for (final stages in completedStages.values) {
      total += stages.length;
    }
    return total;
  }

  int getTotalStars() {
    int total = 0;
    for (final stars in starsPerLocation.values) {
      total += stars;
    }
    return total;
  }

  PlayerProgress copyWith({
    Map<String, List<int>>? completedStages,
    Map<String, int>? starsPerLocation,
    int? currentLocationId,
    int? currentStageId,
    int? totalCoins,
    DateTime? lastPlayed,
  }) {
    return PlayerProgress(
      completedStages: completedStages ?? this.completedStages,
      starsPerLocation: starsPerLocation ?? this.starsPerLocation,
      currentLocationId: currentLocationId ?? this.currentLocationId,
      currentStageId: currentStageId ?? this.currentStageId,
      totalCoins: totalCoins ?? this.totalCoins,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedStages': completedStages,
      'starsPerLocation': starsPerLocation,
      'currentLocationId': currentLocationId,
      'currentStageId': currentStageId,
      'totalCoins': totalCoins,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      completedStages: Map<String, List<int>>.from(
        (json['completedStages'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, List<int>.from(value)),
            ) ??
            {},
      ),
      starsPerLocation: Map<String, int>.from(
        json['starsPerLocation'] as Map<String, dynamic>? ?? {},
      ),
      currentLocationId: json['currentLocationId'] ?? 0,
      currentStageId: json['currentStageId'] ?? 0,
      totalCoins: json['totalCoins'] ?? 0,
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'])
          : DateTime.now(),
    );
  }
}