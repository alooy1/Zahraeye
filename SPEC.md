# Zahra Eye - Game Specification Document

## Project Overview

**Project Name:** Zahra Eye
**Type:** Mobile Game (Flutter + Flame Engine)
**Genre:** Spiritual Cinematic Adventure / Puzzle Game

### Core Concept
A premium mobile puzzle adventure game where players explore sacred holy Islamic locations through an immersive galaxy-themed world map. Players progress through 12 challenging stages per location, answering religious/trivia questions using various innovative puzzle mechanics.

---

## 1. Technical Architecture

### 1.1 Technology Stack
- **Engine:** Flutter 3.x + Flame Engine 1.18+
- **State Management:** Riverpod 2.x
- **Navigation:** GoRouter 14.x
- **Database:** Hive 2.x (for local storage)
- **Audio:** audioplayers 6.x
- **Animations:** Flame animations + custom Tween sequences
- **Architecture:** Clean Architecture (Domain → Data → Presentation)

### 1.2 Project Structure
```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── extensions/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
├── game/
│   ├── components/
│   ├── overlays/
│   └── systems/
└── main.dart
```

### 1.3 Key Systems
- **GameEngine:** Flame-based game loop
- **WorldMapSystem:** Pan/zoom/inertia camera
- **PuzzleEngine:** Modular puzzle type system
- **QuestionSystem:** Dynamic JSON-based question loading
- **AudioSystem:** Background music + SFX
- **SaveSystem:** Hive-based progress persistence

---

## 2. Visual & UI Specification

### 2.1 Color Palette
- **Primary:** Deep Purple (#6B21A8)
- **Secondary:** Royal Blue (#1E40AF)
- **Accent:** Golden Glow (#FCD34D)
- **Background:** Dark Galaxy (#0F0A1F)
- **Surface:** Glassmorphism White (10% opacity)
- **Text Primary:** White (#FFFFFF)
- **Text Secondary:** Light Purple (#A78BFA)
- **Success:** Emerald (#10B981)
- **Error:** Rose (#F43F5E)

### 2.2 Typography
- **Display:** Poppins Bold (Logo/Headers)
- **Body:** Poppins Regular
- **Arabic:** Cairo (for Arabic text support)

### 2.3 UI Components
1. **GlassCard** - Frosted glass containers
2. **GlowButton** - Animated glowing buttons
3. **ParticleBackground** - Galaxy particle system
4. **LocationNode** - Holy place map markers
5. **StageNode** - Circular progression nodes
6. **PuzzleLetter** - Interactive letter tiles
7. **ProgressBar** - Animated progress indicators

---

## 3. Game World Structure

### 3.1 Holy Locations (9 Total)
| # | Location Name | Stages | Unlocked By |
|---|---------------|--------|-------------|
| 1 | Prophet Mosque (Al-Masjid an-Nabawi) | 12 | Initial |
| 2 | Imam Ali Shrine (Kufa) | 12 | Complete Location 1 |
| 3 | Al-Baqi Cemetery | 12 | Complete Location 2 |
| 4 | Imam Hussein & Abbas Shrines (Karbala) | 12 | Complete Location 3 |
| 5 | Al-Kadhimiya Shrine | 12 | Complete Location 4 |
| 6 | Al-Askari Shrine | 12 | Complete Location 5 |
| 7 | Great Mosque of Kufa | 12 | Complete Location 6 |
| 8 | Palace of Al-Qa'im | 12 | Complete Location 7 |
| 9 | Fatima Palace (Final) | 12 | Complete Location 8 |

### 3.2 World Map Features
- **Camera Controls:** Drag (all directions), pinch zoom, inertia movement
- **Background:** Animated purple galaxy with:
  - Twinkling stars (200+ particles)
  - Nebula clouds (3 layers parallax)
  - Floating dust particles
  - Ambient glow orbs
- **Location Nodes:** Glowing markers with pulse animation
- **Transitions:** Cinematic zoom-to-location animation

### 3.3 Location Backgrounds
Each location has unique animated backgrounds:
- **Prophet Mosque:** Golden architectural grandeur
- **Imam Ali Shrine:** Green mystical atmosphere
- **Al-Baqi:** Serene cemetery twilight
- **Karbala:** Red/gold spiritual interior
- **Al-Kadhimiya:** Blue sacred chambers
- **Al-Askari:** Golden mystical hall
- **Kufa Mosque:** Ancient spiritual aura
- **Al-Qa'im Palace:** Royal purple elegance
- **Fatima Palace:** Ruby crystal floating palace

---

## 4. Puzzle System Specification

### 4.1 Puzzle Types (10 Variants)

1. **Swipe Connect**
   - Drag finger to connect letters
   - Glowing trail effect
   - Magnetic snap to letters

2. **Hidden Word Search**
   - Grid of letters (5x5 to 8x8)
   - Find hidden words in any direction
   - Animated selection highlight

3. **Rune Symbol Decode**
   - Mystical symbol grid
   - Match symbols to meanings
   - Animated glyph transformations

4. **Rotating Ring**
   - Concentric rotating rings
   - Align letters to form answer
   - Smooth rotation physics

5. **Fragment Merge**
   - Drag fragments together
   - Combine to form complete word
   - Merge animation effect

6. **Multi-Layer Reveal**
   - Layered letter display
   - Unlock layers progressively
   - Shimmer reveal animation

7. **Memory Match**
   - Flip cards to find matching pairs
   - Glowing card backs
   - Match sequence validation

8. **Energy Path**
   - Connect sacred energy points
   - Path glows when correct
   - Energy flow animation

9. **Symbol Matching**
   - Match sacred symbols to meanings
   - Drag-and-drop interface
   - Correct match glow

10. **Cinematic Boss**
    - Combined mechanics for final stages
    - Multi-phase puzzle
    - Epic completion animation

### 4.2 Puzzle Data Structure (JSON)
```json
{
  "stage_id": 1,
  "question": "Question text here?",
  "answer": "ANSWER",
  "puzzle_type": "swipe_connect",
  "difficulty": 1,
  "hints": ["Hint 1", "Hint 2"],
  "time_limit": 120,
  "rewards": {
    "stars": 3,
    "coins": 100
  }
}
```

### 4.3 Question Storage Structure
```
assets/
└── data/
    ├── questions/
    │   ├── prophet_mosque.json
    │   ├── imam_ali.json
    │   ├── baqi.json
    │   ├── karbala.json
    │   ├── kadhimiya.json
    │   ├── askari.json
    │   ├── kufa_mosque.json
    │   ├── qaim_palace.json
    │   └── fatima_palace.json
    └── settings.json
```

---

## 5. Audio Specification

### 5.1 Audio Categories
1. **Background Music**
   - Galaxy theme (main menu)
   - Location themes (per location)
   - Puzzle concentration music

2. **SFX - UI**
   - Button tap
   - Menu open/close
   - Stage unlock
   - Progress achieved

3. **SFX - Puzzle**
   - Letter tap
   - Correct answer (chime)
   - Wrong answer (subtle)
   - Puzzle complete (fanfare)
   - Hint used

4. **SFX - Ambient**
   - Galaxy ambient
   - Holy location atmosphere

### 5.2 Audio Implementation
- Lazy load audio assets
- Background music fades between screens
- SFX pool for rapid playback
- Volume controls in settings

---

## 6. Progression & Save System

### 6.1 Player Progress
- Completed stages per location
- Stars earned (1-3 per stage)
- Total coins
- Unlocked locations
- Current streak

### 6.2 Save Data Structure (Hive)
```dart
@HiveType(typeId: 0)
class PlayerProgress {
  @HiveField(0) List<int> completedStages; // [locationId][stageId]
  @HiveField(1) Map<int, int> starsEarned;
  @HiveField(2) int totalCoins;
  @HiveField(3) int currentLocation;
  @HiveField(4) int currentStage;
  @HiveField(5) DateTime lastPlayed;
}
```

---

## 7. Performance Requirements

- **Target FPS:** 60 FPS minimum
- **Asset Size:** Optimized textures (max 2048x2048)
- **Loading:** Lazy loading for all assets
- **Memory:** Efficient sprite caching
- **Build:** Release mode with tree shaking

---

## 8. Monetization Architecture (Future-Ready)

- Ad placement hooks (interstitial between stages)
- IAP SKU constants ready
- Skin system architecture
- Battle pass data models
- Cloud save sync interface

---

## 9. Implementation Phases

### Phase 1: Core Infrastructure
- Project setup + dependencies
- Theme system + constants
- Navigation setup
- Audio system foundation
- Save system

### Phase 2: World Map
- Galaxy background components
- Camera system (pan/zoom/inertia)
- Location node rendering
- Location selection transitions

### Phase 3: Stage System
- Stage node UI
- Location background system
- Question loading system
- Stage progression logic

### Phase 4: Puzzle Engine
- Base puzzle architecture
- Swipe Connect implementation
- Hidden Word implementation
- Remaining puzzle types

### Phase 5: Polish
- Animation polish
- Particle effects
- Audio integration
- UI refinements
- Performance optimization

---

## 10. Acceptance Criteria

1. ✓ Game launches with cinematic intro
2. ✓ World map is navigable with smooth camera
3. ✓ All 9 locations are displayed and accessible
4. ✓ Each location shows 12 stage nodes
5. ✓ Questions load dynamically from JSON
6. ✓ Multiple puzzle types work correctly
7. ✓ Progress saves to local storage
8. ✓ Audio plays appropriately
9. ✓ UI feels premium and cinematic
10. ✓ Performance maintains 60 FPS