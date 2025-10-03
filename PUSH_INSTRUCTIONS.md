# Instructions to Push Branch and Create PR

## ✅ Current Status

The branch `feature/integrate-persistence-and-i18n` is ready with these commits:
- `b37e47a` - feat: Initialize storage and add localization support in main.dart
- `7a1dc21` - docs: Add PR summary for localization integration

All changes are committed locally and ready to push.

## 🔑 SSH Key Issue

Your SSH key is **encrypted with a passphrase**. The automated push cannot proceed without the passphrase.

## 📋 Manual Steps to Push and Create PR

### Option 1: Push from Your Local Machine (Recommended)

```bash
# 1. Navigate to your local repository
cd /path/to/Equation-Builder-Dash-Game

# 2. Fetch all branches from remote
git fetch --all

# 3. Checkout the feature branch
git checkout feature/integrate-persistence-and-i18n

# 4. Pull the commits (if not already present locally)
git pull origin feature/integrate-persistence-and-i18n

# 5. Push to GitHub (will use your existing SSH key with passphrase)
git push origin feature/integrate-persistence-and-i18n

# 6. Create the PR
gh pr create \
  --title "feat: Integrate localization and storage initialization" \
  --body-file PR_SUMMARY_LOCALIZATION_INTEGRATION.md \
  --base main \
  --head feature/integrate-persistence-and-i18n
```

### Option 2: Apply Changes as Patch

If you don't have the branch locally yet, you can apply the changes as a patch:

```bash
# 1. In your local repository
cd /path/to/Equation-Builder-Dash-Game

# 2. Make sure you're on main and up to date
git checkout main
git pull origin main

# 3. Create the feature branch
git checkout -b feature/integrate-persistence-and-i18n

# 4. Apply the changes manually to lib/main.dart
# Copy the changes from the diff below

# 5. Commit the changes
git add lib/main.dart
git commit -m "feat: Initialize storage and add localization support in main.dart

- Add async main() to initialize StorageManager
- Add localization delegates (AppLocalizations, GlobalMaterialLocalizations, etc.)
- Support 3 locales: English (en), Arabic (ar), French (fr)
- Load saved language preference on app startup
- Add changeLocale() method to switch languages at runtime
- Import required packages for localization and storage"

# 6. Copy PR_SUMMARY_LOCALIZATION_INTEGRATION.md from this environment

# 7. Add documentation
git add PR_SUMMARY_LOCALIZATION_INTEGRATION.md
git commit -m "docs: Add PR summary for localization integration"

# 8. Push to GitHub
git push origin feature/integrate-persistence-and-i18n

# 9. Create PR
gh pr create \
  --title "feat: Integrate localization and storage initialization" \
  --body-file PR_SUMMARY_LOCALIZATION_INTEGRATION.md \
  --base main \
  --head feature/integrate-persistence-and-i18n
```

### Option 3: Use GitHub Web Interface

1. **Push the branch first** (using your local terminal with SSH passphrase):
   ```bash
   git push origin feature/integrate-persistence-and-i18n
   ```

2. **Create PR on GitHub:**
   - Go to: https://github.com/mosabry99/Equation-Builder-Dash-Game
   - Click "Pull requests" → "New pull request"
   - Base: `main`, Compare: `feature/integrate-persistence-and-i18n`
   - Title: `feat: Integrate localization and storage initialization`
   - Description: Copy content from `PR_SUMMARY_LOCALIZATION_INTEGRATION.md`
   - Click "Create pull request"

## 📝 Changes Summary

### File Modified: `lib/main.dart`

**Changes made:**
1. Added imports for localization and storage
2. Made `main()` async and initialized StorageManager
3. Added locale state management
4. Configured MaterialApp with localization delegates
5. Added support for 3 languages (en, ar, fr)

**Lines changed:** +38, -1

### See Full Details
All details are in `PR_SUMMARY_LOCALIZATION_INTEGRATION.md` in the repository.

## 🔍 Quick Verification

Once pushed, verify the branch exists:
```bash
git ls-remote origin feature/integrate-persistence-and-i18n
```

## ❓ Troubleshooting

### If you get "branch not found":
The commits are in this remote environment. You'll need to either:
1. Pull from the remote environment (if possible)
2. Apply the changes manually using the patch/diff

### If SSH asks for passphrase:
This is normal - your SSH key is encrypted for security. Enter your passphrase when prompted.

### If you want to use HTTPS instead:
```bash
git remote set-url origin https://github.com/mosabry99/Equation-Builder-Dash-Game.git
git push origin feature/integrate-persistence-and-i18n
# You'll be prompted for GitHub credentials
```

## 📄 Files to Reference

1. **PR_SUMMARY_LOCALIZATION_INTEGRATION.md** - Complete PR description
2. **IMPLEMENTATION_PLAN.md** - Overall implementation roadmap
3. **lib/main.dart** - The modified file (see diff below)

## 🔧 The Exact Changes (for manual application)

### lib/main.dart - Changes to apply:

**Add imports at the top:**
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'managers/storage_manager.dart';
import 'l10n/app_localizations.dart';
```

**Change main() function:**
```dart
// Before:
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ...
}

// After:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageManager().initialize();
  
  // ... rest of main
}
```

**Update _EquationBuilderAppState class:**
```dart
class _EquationBuilderAppState extends State<EquationBuilderApp> {
  bool _showSplash = true;
  final SettingsManager _settings = SettingsManager();
  late Locale _locale;  // ADD THIS

  @override
  void initState() {  // ADD THIS METHOD
    super.initState();
    _loadLocale();
  }

  void _loadLocale() {  // ADD THIS METHOD
    final languageCode = StorageManager().getLanguage();
    _locale = Locale(languageCode);
  }

  void _updateTheme() {
    setState(() {
      // Force rebuild with new theme
    });
  }

  void changeLocale(Locale locale) {  // ADD THIS METHOD
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
      locale: _locale,  // ADD THIS
      localizationsDelegates: const [  // ADD THIS
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [  // ADD THIS
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('fr'), // French
      ],
      // ... rest of MaterialApp config
    );
  }
}
```

## ✅ Next Steps After PR is Created

1. **Run tests locally:**
   ```bash
   flutter pub get
   flutter analyze
   flutter test
   flutter run
   ```

2. **Verify functionality:**
   - App should start without errors
   - Storage should be initialized
   - Default language should be English

3. **Review the PR** on GitHub

4. **Merge when ready** and proceed with remaining integration work

---

**Branch:** `feature/integrate-persistence-and-i18n`  
**Status:** Ready to push (commits are local in remote environment)  
**Commits:** 2  
**Files changed:** 2 (lib/main.dart, PR_SUMMARY_LOCALIZATION_INTEGRATION.md)
