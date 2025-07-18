import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/utils/extensions/string_extension.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

class ThemeProvider extends ChangeNotifier {
  /// If need to implement theme - then use it.
  ThemeMode _currentThemeMode = SharedPrefs().theme?.toTheme ?? ThemeMode.light;

  ThemeMode get currentThemeMode => _currentThemeMode;

  void changeThemeMode(ThemeMode newThemeMode) {
    _currentThemeMode = newThemeMode;
    SharedPrefs().setTheme(newThemeMode.name);
    notifyListeners();
  }
}
