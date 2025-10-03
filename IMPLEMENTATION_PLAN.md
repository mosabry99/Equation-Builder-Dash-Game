# Implementation Plan - Persistence, i18n & UI Improvements

## 🎯 User Requirements

1. **Save level and stats** using SharedPreferences - load on startup
2. **Improve game header** - remove shadows, better organization
3. **Fix music toggle colors** - consistent with other toggles
4. **Add About section** - Privacy Policy & Terms of Use links
5. **Multi-language support** - English, Arabic, French

---

## ✅ Completed So Far

### 1. **Dependencies Added** (pubspec.yaml)
- ✅ `shared_preferences: ^2.2.2`
- ✅ `url_launcher: ^6.2.2`
- ✅ `flutter_localizations` (SDK)
- ✅ `intl: ^0.19.0`

### 2. **Storage Manager** (lib/managers/storage_manager.dart)
- ✅ Save/load level
- ✅ Save/load score
- ✅ Track high score
- ✅ Track total games
- ✅ Save/load language preference
- ✅ Reset progress functionality

### 3. **Localization System** (lib/l10n/app_localizations.dart)
- ✅ English translations
- ✅ Arabic translations (العربية)
- ✅ French translations (Français)
- ✅ All app strings covered:
  - Main menu
  - Game UI
  - Settings
  - About
  - Dialogs

### 4. **About Screen** (lib/screens/about_screen.dart)
- ✅ App info and version
- ✅ Privacy Policy link
- ✅ Terms of Use link
- ✅ Rate App option
- ✅ Theme-aware design
- ✅ Localized

---

## 🔨 Remaining Work

### 1. **Update Main.dart** - Initialize Storage & Localization
```dart
// Add to main():
- Initialize StorageManager
- Set up localization delegates
- Load saved language
- Set up locale

// MaterialApp:
- Add localizationsDelegates
- Add supportedLocales
- Set locale based on saved preference
```

### 2. **Update Game** - Load/Save Progress
```dart
// In EquationBuilderGame:
- Load saved level on init
- Load saved score on init
- Save level after each level up
- Save score after changes
- Increment total games on game over
```

### 3. **Update HUD Component** - Improve Header
```dart
// In HudComponent:
- Remove all shadows/glow effects
- Clean layout with clear spacing
- Better organization:
  * Level | Score (top row)
  * Target | Current Sum (second row)
- Simple text, no effects
- Localized labels
```

### 4. **Update Settings Screen**
```dart
// Add:
- Language selector (English/Arabic/French)
- Statistics section:
  * High Score
  * Total Games
  * Reset Progress button
- Fix music toggle colors (use theme colors)
- Localize all strings
- Add About button
```

### 5. **Update Main Menu Screen**
```dart
// Add:
- About button
- Localize all strings
- Load/display high score (optional)
```

### 6. **Update Game Over Dialog**
```dart
- Localize strings
- Use l10n for text
```

### 7. **Fix Music Toggle Colors**
```dart
// In settings_screen.dart:
Background Music toggle should use:
- Dark mode: Purple/magenta (same as current)
- Light mode: Orange (#ffa726) - matching sound effects style
```

---

## 📝 Detailed Implementation Steps

### Step 1: Update main.dart

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'managers/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageManager().initialize();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const EquationBuilderApp());
}

class _EquationBuilderAppState extends State<EquationBuilderApp> {
  Locale _locale = const Locale('en');
  
  @override
  void initState() {
    super.initState();
    _loadLocale();
  }
  
  void _loadLocale() {
    final languageCode = StorageManager().getLanguage();
    setState(() {
      _locale = Locale(languageCode);
    });
  }
  
  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    StorageManager().saveLanguage(locale.languageCode);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equation Builder Dash',
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
      ],
      // ... rest of MaterialApp config
    );
  }
}
```

### Step 2: Update Game - Load/Save

```dart
// In EquationBuilderGame class:

final StorageManager storage = StorageManager();

@override
Future<void> onLoad() async {
  await super.onLoad();
  
  // Load saved progress
  level = storage.getLevel();
  score = storage.getScore();
  
  // Initialize with loaded level
  equationManager = EquationManager(level: level);
  
  // ... rest of init
}

void _handleSuccess() {
  // ... existing code
  
  // Save progress
  storage.saveLevel(level);
  storage.saveScore(score);
}

void _showGameOverDialog() {
  // ... existing code
  
  // Increment total games
  storage.incrementTotalGames();
  
  // Reset progress if needed
  storage.resetProgress();
}
```

### Step 3: Update HUD - Clean Header

```dart
// In HudComponent render method:

// Remove all shadow/glow paints
// Simple clean text:

final levelText = 'Level $level';
final scoreText = 'Score: $score';
final targetText = 'Target: $target';
final sumText = 'Sum: $currentSum';

// Draw with simple TextPaint, no shadows
// Organized layout:
/*
  Level 5        Score: 150
  Target: 20     Sum: 12
*/
```

### Step 4: Update Settings Screen

Add sections:
1. Language Selector
2. Statistics Display
3. About Button
4. Fix toggle colors

```dart
// Language Dropdown
DropdownButton<Locale>(
  value: _currentLocale,
  items: [
    DropdownMenuItem(value: Locale('en'), child: Text('English')),
    DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
    DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
  ],
  onChanged: (locale) => _changeLanguage(locale),
)

// Statistics
Text('High Score: ${storage.getHighScore()}')
Text('Total Games: ${storage.getTotalGames()}')

// Reset Button
ElevatedButton(
  onPressed: _showResetDialog,
  child: Text(l10n.resetProgress),
)

// About Button
ListTile(
  leading: Icon(Icons.info),
  title: Text(l10n.about),
  onTap: () => Navigator.push(...AboutScreen()),
)
```

---

## 🧪 Testing Checklist

- [ ] SharedPreferences saves and loads level
- [ ] SharedPreferences saves and loads score
- [ ] High score updates correctly
- [ ] Total games increments on game over
- [ ] Language switches work (EN/AR/FR)
- [ ] All UI text is localized
- [ ] About screen links work
- [ ] HUD header is clean (no shadows)
- [ ] Music toggle colors match other toggles
- [ ] Reset progress works
- [ ] Progress persists across app restarts

---

## 📦 Files to Update

1. ✅ `pubspec.yaml` - Dependencies
2. ✅ `lib/managers/storage_manager.dart` - NEW
3. ✅ `lib/l10n/app_localizations.dart` - NEW
4. ✅ `lib/screens/about_screen.dart` - NEW
5. ⏳ `lib/main.dart` - Add localization & storage init
6. ⏳ `lib/game/equation_builder_game.dart` - Load/save progress
7. ⏳ `lib/components/hud_component.dart` - Clean header, no shadows
8. ⏳ `lib/screens/settings_screen.dart` - Add language, stats, fix colors
9. ⏳ `lib/screens/main_menu_screen.dart` - Localize & add About button
10. ⏳ `lib/widgets/game_over_dialog.dart` - Localize strings

---

## 🎨 Color Reference - Toggle Buttons

All toggles should have consistent colors:

**Dark Mode:**
- Dark Mode toggle: Cyan (`#00ffff`)
- Sound Effects toggle: Cyan (`#00ffff`)
- Background Music toggle: Purple (`#a29bfe` or similar)

**Light Mode:**
- Dark Mode toggle: Blue (`#1976d2`)
- Sound Effects toggle: Green (`#26de81`)
- Background Music toggle: Orange (`#ffa726`)

---

## 📋 Summary

**Completed:**
- Storage system (SharedPreferences)
- Localization system (3 languages)
- About screen with links
- Dependencies added

**Remaining:**
- Wire up storage to game
- Update all UI with localization
- Improve HUD header
- Fix toggle colors
- Add language selector
- Add statistics display
- Test everything

**Estimated Remaining Work:** ~2-3 hours

This is a solid foundation. The core systems are in place, now just need to integrate them into existing screens and components.
