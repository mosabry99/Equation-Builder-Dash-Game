import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appTitle': 'Equation Builder Dash',
      
      // Main Menu
      'gameTitle': 'Equation Builder',
      'gameSubtitle': 'Dash Game',
      'startPlay': 'START PLAY',
      'settings': 'SETTINGS',
      'about': 'ABOUT',
      'tagline': 'Collect numbers to reach the target!',
      
      // Game
      'level': 'Level',
      'score': 'Score',
      'target': 'Target',
      'currentSum': 'Sum',
      'hint': 'Collect numbers to match target',
      
      // Game Over
      'gameOver': 'Game Over!',
      'gameOverMessage': 'You can\'t reach the target with these numbers.\nWould you like to restart or quit?',
      'restart': 'RESTART',
      'quit': 'QUIT',
      
      // Settings
      'settingsTitle': 'Settings',
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'audio': 'Audio',
      'soundEffects': 'Sound Effects',
      'backgroundMusic': 'Background Music',
      'gameplay': 'Gameplay',
      'language': 'Language',
      'statistics': 'Statistics',
      'highScore': 'High Score',
      'totalGames': 'Total Games',
      'resetProgress': 'Reset Progress',
      
      // About
      'aboutTitle': 'About',
      'version': 'Version',
      'developer': 'Developer',
      'description': 'An arcade math-reflex game built with Flutter Flame',
      'privacyPolicy': 'Privacy Policy',
      'termsOfUse': 'Terms of Use',
      'support': 'Support',
      'rateApp': 'Rate App',
      
      // Languages
      'english': 'English',
      'arabic': 'العربية',
      'french': 'Français',
      
      // Dialogs
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'resetProgressTitle': 'Reset Progress',
      'resetProgressMessage': 'Are you sure you want to reset all progress?',
      'yes': 'Yes',
      'no': 'No',
    },
    'ar': {
      // App
      'appTitle': 'لعبة بناء المعادلات',
      
      // Main Menu
      'gameTitle': 'بناء المعادلات',
      'gameSubtitle': 'لعبة السرعة',
      'startPlay': 'ابدأ اللعب',
      'settings': 'الإعدادات',
      'about': 'حول',
      'tagline': 'اجمع الأرقام للوصول إلى الهدف!',
      
      // Game
      'level': 'المستوى',
      'score': 'النقاط',
      'target': 'الهدف',
      'currentSum': 'المجموع',
      'hint': 'اجمع الأرقام لمطابقة الهدف',
      
      // Game Over
      'gameOver': 'انتهت اللعبة!',
      'gameOverMessage': 'لا يمكنك الوصول إلى الهدف بهذه الأرقام.\nهل تريد إعادة التشغيل أو الخروج?',
      'restart': 'إعادة',
      'quit': 'خروج',
      
      // Settings
      'settingsTitle': 'الإعدادات',
      'appearance': 'المظهر',
      'darkMode': 'الوضع الداكن',
      'audio': 'الصوت',
      'soundEffects': 'المؤثرات الصوتية',
      'backgroundMusic': 'موسيقى الخلفية',
      'gameplay': 'اللعب',
      'language': 'اللغة',
      'statistics': 'الإحصائيات',
      'highScore': 'أعلى نقاط',
      'totalGames': 'إجمالي الألعاب',
      'resetProgress': 'إعادة تعيين التقدم',
      
      // About
      'aboutTitle': 'حول',
      'version': 'الإصدار',
      'developer': 'المطور',
      'description': 'لعبة رياضيات أركيد مبنية بـ Flutter Flame',
      'privacyPolicy': 'سياسة الخصوصية',
      'termsOfUse': 'شروط الاستخدام',
      'support': 'الدعم',
      'rateApp': 'قيم التطبيق',
      
      // Languages
      'english': 'English',
      'arabic': 'العربية',
      'french': 'Français',
      
      // Dialogs
      'confirm': 'تأكيد',
      'cancel': 'إلغاء',
      'resetProgressTitle': 'إعادة تعيين التقدم',
      'resetProgressMessage': 'هل أنت متأكد أنك تريد إعادة تعيين كل التقدم?',
      'yes': 'نعم',
      'no': 'لا',
    },
    'fr': {
      // App
      'appTitle': 'Jeu de Construction d\'Équations',
      
      // Main Menu
      'gameTitle': 'Constructeur d\'Équations',
      'gameSubtitle': 'Jeu Dash',
      'startPlay': 'COMMENCER',
      'settings': 'PARAMÈTRES',
      'about': 'À PROPOS',
      'tagline': 'Collectez des nombres pour atteindre la cible!',
      
      // Game
      'level': 'Niveau',
      'score': 'Score',
      'target': 'Cible',
      'currentSum': 'Somme',
      'hint': 'Collectez des nombres pour correspondre à la cible',
      
      // Game Over
      'gameOver': 'Jeu Terminé!',
      'gameOverMessage': 'Vous ne pouvez pas atteindre la cible avec ces nombres.\nVoulez-vous recommencer ou quitter?',
      'restart': 'RECOMMENCER',
      'quit': 'QUITTER',
      
      // Settings
      'settingsTitle': 'Paramètres',
      'appearance': 'Apparence',
      'darkMode': 'Mode Sombre',
      'audio': 'Audio',
      'soundEffects': 'Effets Sonores',
      'backgroundMusic': 'Musique de Fond',
      'gameplay': 'Gameplay',
      'language': 'Langue',
      'statistics': 'Statistiques',
      'highScore': 'Meilleur Score',
      'totalGames': 'Total de Jeux',
      'resetProgress': 'Réinitialiser la Progression',
      
      // About
      'aboutTitle': 'À Propos',
      'version': 'Version',
      'developer': 'Développeur',
      'description': 'Un jeu de réflexes mathématiques construit avec Flutter Flame',
      'privacyPolicy': 'Politique de Confidentialité',
      'termsOfUse': 'Conditions d\'Utilisation',
      'support': 'Support',
      'rateApp': 'Noter l\'Application',
      
      // Languages
      'english': 'English',
      'arabic': 'العربية',
      'french': 'Français',
      
      // Dialogs
      'confirm': 'Confirmer',
      'cancel': 'Annuler',
      'resetProgressTitle': 'Réinitialiser la Progression',
      'resetProgressMessage': 'Êtes-vous sûr de vouloir réinitialiser toute la progression?',
      'yes': 'Oui',
      'no': 'Non',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Helper getters
  String get appTitle => translate('appTitle');
  String get gameTitle => translate('gameTitle');
  String get gameSubtitle => translate('gameSubtitle');
  String get startPlay => translate('startPlay');
  String get settings => translate('settings');
  String get about => translate('about');
  String get tagline => translate('tagline');
  
  String get level => translate('level');
  String get score => translate('score');
  String get target => translate('target');
  String get currentSum => translate('currentSum');
  String get hint => translate('hint');
  
  String get gameOver => translate('gameOver');
  String get gameOverMessage => translate('gameOverMessage');
  String get restart => translate('restart');
  String get quit => translate('quit');
  
  String get settingsTitle => translate('settingsTitle');
  String get appearance => translate('appearance');
  String get darkMode => translate('darkMode');
  String get audio => translate('audio');
  String get soundEffects => translate('soundEffects');
  String get backgroundMusic => translate('backgroundMusic');
  String get gameplay => translate('gameplay');
  String get language => translate('language');
  String get statistics => translate('statistics');
  String get highScore => translate('highScore');
  String get totalGames => translate('totalGames');
  String get resetProgress => translate('resetProgress');
  
  String get aboutTitle => translate('aboutTitle');
  String get version => translate('version');
  String get developer => translate('developer');
  String get description => translate('description');
  String get privacyPolicy => translate('privacyPolicy');
  String get termsOfUse => translate('termsOfUse');
  String get support => translate('support');
  String get rateApp => translate('rateApp');
  
  String get english => translate('english');
  String get arabic => translate('arabic');
  String get french => translate('french');
  
  String get confirm => translate('confirm');
  String get cancel => translate('cancel');
  String get resetProgressTitle => translate('resetProgressTitle');
  String get resetProgressMessage => translate('resetProgressMessage');
  String get yes => translate('yes');
  String get no => translate('no');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
