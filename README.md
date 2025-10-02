# 🥈 Equation Builder Dash

An arcade math-reflex game built with Flutter Flame! Test your math skills and reflexes by catching falling numbers and operators to build equations that match the target.

![Game Preview](https://img.shields.io/badge/Flutter-Flame-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)

## 🎮 Game Concept

Numbers and operators fall from the top of the screen. Move left and right to collect them and build an equation matching the target result shown in the HUD.

- ✅ **Correct equation** → Success animation + next level
- ❌ **Wrong equation** → Explosion animation + funny fail message
- 🚀 **Progressive difficulty** → Each level increases speed and complexity

## ✨ Features

### Core Gameplay
- 🎯 Dynamic target generation
- 🔢 Falling digits (0-9) and operators (+, −, ×, ÷)
- 🎮 Smooth keyboard controls (arrow keys, space/enter, backspace)
- 💥 Particle effects for success and failure
- 📊 Progressive difficulty across 4+ levels

### Visual Effects
- 🌌 Neon cyber-arcade theme with gradient backgrounds
- 💎 Glassmorphism HUD with glowing text
- ✨ Confetti burst on success
- 💥 Explosion particles on failure
- 🎨 Drop shadows and glow effects

### Level Progression
1. **Level 1** → Addition only (+), slower speed
2. **Level 2** → Addition and subtraction (+, −)
3. **Level 3** → All operations (+, −, ×, ÷)
4. **Endless** → Faster speeds, complex multi-step equations

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mosabry99/Equation-Builder-Dash-Game.git
   cd Equation-Builder-Dash-Game
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the game**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 🎮 How to Play

### Controls
- **←/→ Arrow Keys** - Move player left/right
- **Space/Enter** - Submit equation
- **Backspace** - Undo last collected item

### Objective
1. Watch the **TARGET** number in the HUD
2. Collect falling numbers and operators
3. Build an equation that equals the target
4. Submit with Space/Enter when ready
5. Advance through levels with increasing difficulty!

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── game/
│   └── equation_builder_game.dart    # Main game logic
├── components/
│   ├── player_component.dart         # Player with collision detection
│   ├── falling_component.dart        # Falling numbers/operators
│   ├── hud_component.dart            # Heads-up display
│   ├── explosion_effect.dart         # Fail animation
│   └── success_effect.dart           # Success animation
└── managers/
    └── equation_manager.dart         # Math validation logic
```

## 🛠️ Technical Stack

- **Framework:** Flutter 3.0+
- **Game Engine:** Flame 1.15+
- **Language:** Dart 3.0+
- **Architecture:** Component-based ECS (Entity Component System)

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flame: ^1.15.0
  flame_audio: ^2.1.0
```

## 🎨 Design Philosophy

### Neon Cyber-Arcade Theme
- Dark gradient backgrounds (purple/blue tones)
- Glowing cyan and yellow accents
- Glassmorphism UI elements
- Particle effects with vibrant colors

### Modular Component Design
- **PlayerComponent** - Handles movement and collision
- **FallingComponent** - Manages falling items lifecycle
- **HudComponent** - Displays game state
- **EquationManager** - Encapsulates math logic
- **Effects** - Reusable visual feedback components

## 🧪 Testing & Quality

Run static analysis:
```bash
flutter analyze
```

Run tests:
```bash
flutter test
```

Check formatting:
```bash
dart format --set-exit-if-changed .
```

## 📝 Math Validation

The game uses proper order of operations (PEMDAS):
1. Multiplication (×) and Division (÷) first
2. Addition (+) and Subtraction (−) second

Example: `5 + 3 × 2` = `5 + 6` = `11` ✓

## 🎯 Future Enhancements

- 🔊 Sound effects and background music
- 📱 Touch controls for mobile
- 🏆 Global leaderboard
- 💾 High score persistence
- 🎭 Character skins
- 🌍 Internationalization
- 🎥 Replay failed attempts
- 🏅 Daily challenges

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**mosabry99**
- GitHub: [@mosabry99](https://github.com/mosabry99)

## 🙏 Acknowledgments

- Built with [Flutter Flame](https://flame-engine.org/)
- Inspired by classic arcade reflex games
- Emoji icons from Unicode Standard

---

**Made with ❤️ and Dart**