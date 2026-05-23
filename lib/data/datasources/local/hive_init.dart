import 'package:hive_flutter/hive_flutter.dart';

class HiveInit {
  static const String playerProgressBox = 'player_progress';
  static const String settingsBox = 'settings';

  static Future<void> init() async {
    // Open boxes
    await Hive.openBox(playerProgressBox);
    await Hive.openBox(settingsBox);
  }

  static Box get playerProgressBoxInstance => Hive.box(playerProgressBox);
  static Box get settingsBoxInstance => Hive.box(settingsBox);
}