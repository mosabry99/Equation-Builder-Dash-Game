import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flame/game.dart';
import 'game/equation_builder_game.dart';
import 'screens/splash_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/settings_screen.dart';
import 'managers/settings_manager.dart';
import 'managers/storage_manager.dart';
import 'l10n/app_localizations.dart';
import 'widgets/game_over_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageManager().initialize();
  
  // Lock to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const EquationBuilderApp());
}

class EquationBuilderApp extends StatefulWidget {
  const EquationBuilderApp({super.key});

  @override
  State<EquationBuilderApp> createState() => _EquationBuilderAppState();
}

class _EquationBuilderAppState extends State<EquationBuilderApp> {
  bool _showSplash = true;
  final SettingsManager _settings = SettingsManager();
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() {
    final languageCode = StorageManager().getLanguage();
    _locale = Locale(languageCode);
  }

  void _updateTheme() {
    setState(() {
      // Force rebuild with new theme
    });
  }

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    StorageManager().saveLanguage(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equation Builder Dash',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('fr'), // French
      ],
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFe3f2fd),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1976d2),
          secondary: Color(0xFF00bcd4),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0a0e27),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00ffff),
          secondary: Color(0xFF6c5ce7),
        ),
      ),
      themeMode: _settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _showSplash
          ? SplashScreen(
              onComplete: () {
                setState(() {
                  _showSplash = false;
                });
              },
            )
          : const MainMenuScreen(), // Show main menu after splash
    );
  }
}

class GameScreen extends StatefulWidget {
  final VoidCallback? onThemeChanged;
  
  const GameScreen({super.key, this.onThemeChanged});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late EquationBuilderGame _game;
  final SettingsManager _settings = SettingsManager();

  @override
  void initState() {
    super.initState();
    _game = EquationBuilderGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'gameOver': (BuildContext context, EquationBuilderGame game) {
                return GameOverDialog(
                  title: 'Game Over!',
                  message: 'You can\'t reach the target with these numbers.\nWould you like to restart or quit?',
                  isDarkMode: _settings.isDarkMode,
                  onRestart: () {
                    game.restartGame();
                  },
                  onQuit: () {
                    Navigator.of(context).pop();
                  },
                );
              },
            },
          ),
          
          // Settings button
          Positioned(
            top: 40,
            right: 20,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: (_settings.isDarkMode
                          ? const Color(0xFF1a1f3a)
                          : Colors.white)
                      .withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (_settings.isDarkMode
                            ? const Color(0xFF00ffff)
                            : const Color(0xFF1976d2))
                        .withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_settings.isDarkMode
                              ? const Color(0xFF00ffff)
                              : const Color(0xFF1976d2))
                          .withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: _settings.isDarkMode
                        ? const Color(0xFF00ffff)
                        : const Color(0xFF1976d2),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                    setState(() {
                      // Recreate game with new theme
                      _game = EquationBuilderGame();
                    });
                    widget.onThemeChanged?.call();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
