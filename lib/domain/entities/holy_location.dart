import 'package:flutter/material.dart';

class HolyLocation {
  final int id;
  final String nameEn;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final Color themeColor;
  final Color secondaryColor;
  final int totalStages;
  final int unlockedStageCount;
  final bool isUnlocked;
  final double positionX;
  final double positionY;
  final double scale;

  const HolyLocation({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.themeColor,
    required this.secondaryColor,
    required this.totalStages,
    this.unlockedStageCount = 1,
    this.isUnlocked = false,
    required this.positionX,
    required this.positionY,
    this.scale = 1.0,
  });

  HolyLocation copyWith({
    int? id,
    String? nameEn,
    String? nameAr,
    String? description,
    String? descriptionAr,
    Color? themeColor,
    Color? secondaryColor,
    int? totalStages,
    int? unlockedStageCount,
    bool? isUnlocked,
    double? positionX,
    double? positionY,
    double? scale,
  }) {
    return HolyLocation(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      themeColor: themeColor ?? this.themeColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      totalStages: totalStages ?? this.totalStages,
      unlockedStageCount: unlockedStageCount ?? this.unlockedStageCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      scale: scale ?? this.scale,
    );
  }
}

// Holy location data provider
class HolyLocationData {
  static List<HolyLocation> getAllLocations() {
    return [
      const HolyLocation(
        id: 0,
        nameEn: 'Amir al-Mu\'minin zone',
        nameAr: 'أَمِيرُ الْمُؤْمِنِين',
        description: 'Shrine of Imam Ali in Najaf',
        descriptionAr: 'مرقد أمير المؤمنين علي في النجف',
        themeColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 1319,
        positionY: 453,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 1,
        nameEn: 'Prophet Mohamed zone',
        nameAr: 'مِنْطَقَةُ الرَّسُولُ الْأَعْظَم',
        description: 'Al-Masjid an-Nabawi in Medina',
        descriptionAr: 'المسجد النبوي في المدينة المنورة',
        themeColor: Color(0xFFFFFFFF),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 795,
        positionY: 458,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 2,
        nameEn: 'Al-Baqi zone',
        nameAr: 'مِنْطَقَةُ أَئِمَّةِ الْبَقِيع',
        description: 'Historic cemetery in Medina',
        descriptionAr: 'المقبرة التاريخية في المدينة المنورة',
        themeColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 1190,
        positionY: 951,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 3,
        nameEn: 'Imam Hussein zone',
        nameAr: 'مِنْطَقَةُ الْإِمَامُ الْحُسَيْن',
        description: 'Shrine of Imam Hussein & Abbas',
        descriptionAr: 'مرقد الإمامين Hussein و Abbas',
        themeColor: Color(0xFFFFFFFF),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 745,
        positionY: 1357,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 4,
        nameEn: 'Imam Al-Kadhim & Al-Jawad zone',
        nameAr: 'مِنْطَقَةُ الْإِمَامُ الْكَاظِمُ و الْجَوَادُ',
        description: 'Shrine of Imams Kadhimain',
        descriptionAr: 'مرقد الإمامين الكاظمين',
        themeColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 405,
        positionY: 710,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 5,
        nameEn: 'Imam Al-Rida zone',
        nameAr: 'مِنْطَقَةُ الْإِمَامُ الرِّضَا',
        description: 'Historic Kufa Mosque',
        descriptionAr: 'مسجد كوفة التاريخي',
        themeColor: Color(0xFFFFFFFF),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 1076,
        positionY: 1501,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 6,
        nameEn: 'Imam Al-Hadi & Al-Askari zone',
        nameAr: 'مِنْطَقَةُ الْإِمَامُ الْهَادِي و الْعَسْكَرِيُّ',
        description: 'Shrine of Imam Askari',
        descriptionAr: 'مرقد العسكري',
        themeColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 510,
        positionY: 1973,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 7,
        nameEn: 'Al-Qaim Palace',
        nameAr: 'قَصْرُ الْقَائِم',
        description: 'Palace of the Expected Imam',
        descriptionAr: 'قصر Imam المنتظر',
        themeColor: Color(0xFFFFFFFF),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 1200,
        positionY: 1582,
        scale: 1.5,
      ),
      const HolyLocation(
        id: 8,
        nameEn: 'FATIMA Palace',
        nameAr: 'قَصْرُ فَاطِمَة',
        description: 'The Legendary Ruby Palace',
        descriptionAr: 'قصر الياقوت الأسطوري',
        themeColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFFFFFFFF),
        totalStages: 12,
        unlockedStageCount: 12,
        isUnlocked: true,
        positionX: 600,
        positionY: 2389,
        scale: 1.5,
      ),
    ];
  }
}