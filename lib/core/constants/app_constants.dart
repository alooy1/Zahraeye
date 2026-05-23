import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6B21A8);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color accentCyan = Color(0xFF06B6D4);

  // Galaxy Colors
  static const Color galaxyPurple = Color(0xFF1E1B4B);
  static const Color galaxyDark = Color(0xFF0F0A1F);
  static const Color nebulaPink = Color(0xFFBE185D);
  static const Color starGold = Color(0xFFFBBF24);

  // UI Colors
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glowBlue = Color(0xFF60A5FA);
  static const Color glowPurple = Color(0xFFC084FC);

  // Holy Location Theme Colors
  static const Color karbalaGold = Color(0xFFD97706);
  static const Color kufaBronze = Color(0xFF92400E);
  static const Color palaceRuby = Color(0xFFDC2626);
  static const Color prophetGreen = Color(0xFF059669);
  static const Color imamAliSilver = Color(0xFF9CA3AF);

  // State Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFF43F5E);
  static const Color warning = Color(0xFFFBBF24);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient galaxyGradient = LinearGradient(
    colors: [galaxyDark, galaxyPurple, primaryPurple],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  static const double iconSmall = 24.0;
  static const double iconMedium = 32.0;
  static const double iconLarge = 48.0;

  static const double buttonHeight = 56.0;
  static const double inputHeight = 52.0;

  // Game specific
  static const double locationNodeSize = 120.0;
  static const double stageNodeSize = 64.0;
  static const double puzzleTileSize = 56.0;
}

class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 800);
  static const Duration slowest = Duration(milliseconds: 1200);
}

class AppStrings {
  static const String appName = 'Zahra Eye';
  static const String appNameArabic = 'عين الزهراء';

  // Location Names
  static const List<String> locationNames = [
    'Prophet Mosque',
    'Imam Ali Shrine',
    'Al-Baqi Cemetery',
    'Karbala',
    'Al-Kadhimiya',
    'Al-Askari',
    'Great Mosque of Kufa',
    'Al-Qa\'im Palace',
    'Fatima Palace',
  ];

  static const List<String> locationNamesArabic = [
    'مسجد النبي',
    'مرقد أمير المؤمنين',
    'مقبرة البقيع',
    'كربلاء',
    'الكاظمية',
    'العسكرية',
    'مسجد كوفة',
    'قصر القائم',
    'قصر فاطمة',
  ];

  // Puzzle Types
  static const String puzzleSwipeConnect = 'swipe_connect';
  static const String puzzleHiddenWord = 'hidden_word';
  static const String puzzleRuneDecode = 'rune_decode';
  static const String puzzleRotateWheel = 'rotate_wheel';
  static const String puzzleFragmentMerge = 'fragment_merge';
  static const String puzzleMultiLayer = 'multi_layer';
  static const String puzzleMemoryCards = 'memory_cards';
  static const String puzzleEnergyPath = 'energy_path';
  static const String puzzleSymbolMatch = 'symbol_match';
  static const String puzzleBoss = 'boss';
}