import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/services/prefs.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier() : _themeMode = _resolveTheme(Prefs.getThemeMode());

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void setLight() => _setMode(ThemeMode.light, 'light');
  void setDark() => _setMode(ThemeMode.dark, 'dark');
  void setSystem() => _setMode(ThemeMode.system, 'system');

  void toggle() {
    if (_themeMode == ThemeMode.dark) {
      setLight();
    } else {
      setDark();
    }
  }

  void _setMode(ThemeMode mode, String key) {
    _themeMode = mode;
    Prefs.setThemeMode(key);
    notifyListeners();
  }

  static ThemeMode _resolveTheme(String key) {
    switch (key) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

final themeProvider = ChangeNotifierProvider<ThemeNotifier>(
  (_) => ThemeNotifier(),
);

final themeModeProvider = Provider<ThemeMode>(
  (ref) => ref.watch(themeProvider).themeMode,
);
