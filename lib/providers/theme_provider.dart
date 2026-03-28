import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // The current theme state, starting at light mode.
  ThemeMode _themeMode = ThemeMode.light;

  // Getter used by MaterialApp to determine the theme.
  ThemeMode get themeMode => _themeMode;

  // Quick check if dark mode is active.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Toggles the theme based on a boolean input (e.g., from a Switch widget).
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    
    // Notifies all listening widgets (like the main app widget) to update.
    notifyListeners();
  }
}