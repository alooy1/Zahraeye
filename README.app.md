# Zahra Eye - Spiritual Cinematic Puzzle Adventure

A premium mobile puzzle game exploring sacred holy Islamic locations through an immersive purple galaxy-themed world map.

## Features

- 🌌 Cinematic galaxy-themed world map with 9 holy locations
- 🕌 12 challenging puzzle stages per location (108 total)
- 🎮 Multiple puzzle types: Swipe Connect, Hidden Word, Rune Decode, Rotate Wheel
- ✨ Premium glassmorphism UI with animated effects
- 📱 Support for Android & iOS

## Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd zahraeye
   ```

2. **Generate the Flutter project:**
   ```bash
   flutter create .
   ```

3. **Get dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── core/                    # Core utilities, constants, themes
│   ├── constants/           # App constants (colors, dimensions)
│   ├── theme/               # App theme
│   └── router/              # GoRouter navigation
├── data/                    # Data layer
│   ├── datasources/         # Local data sources (Hive, JSON)
│   └── repositories/        # Data repositories
├── domain/                  # Business logic
│   └── entities/            # Domain entities
└── presentation/            # UI layer
    ├── providers/           # Riverpod providers
    ├── pages/               # Screen pages
    └── widgets/             # Reusable widgets
```

## Holy Locations

1. Prophet Mosque (Al-Masjid an-Nabawi)
2. Imam Ali Shrine
3. Al-Baqi Cemetery
4. Karbala (Imam Hussein & Abbas)
5. Al-Kadhimiya Shrine
6. Al-Askari Shrine
7. Great Mosque of Kufa
8. Al-Qa'im Palace
9. Fatima Palace (Final - Ruby Crystal Palace)

## Dynamic Questions

Questions are stored in JSON files under `assets/data/questions/`. You can easily add/edit questions without modifying game code:

- `prophet_mosque.json`
- `imam_ali.json`
- `karbala.json`
- `fatima_palace.json`

## Puzzle Types

1. **Swipe Connect** - Connect letters in sequence
2. **Hidden Word** - Find hidden words in letter grid
3. **Rune Decode** - Decode mystical symbols
4. **Rotate Wheel** - Rotate rings to align letters

## Technology Stack

- **Framework:** Flutter 3.x
- **Game Engine:** Flame 1.x
- **State Management:** Riverpod 2.x
- **Navigation:** GoRouter 14.x
- **Storage:** Hive 2.x

## Configuration

The app supports both Arabic and English languages. The question system fully supports UTF-8 and Arabic script.

## License

Private - All Rights Reserved