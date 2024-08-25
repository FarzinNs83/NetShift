import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dark_light_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _selectedTheme;

  ThemeProvider({required bool isDarkMode})
      : _selectedTheme = isDarkMode ? darkTheme : lightTheme;

  ThemeData get theme => _selectedTheme;

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTheme == darkTheme) {
      _selectedTheme = lightTheme;
      prefs.setBool('isDarkMode', false);
    } else {
      _selectedTheme = darkTheme;
      prefs.setBool('isDarkMode', true);
    }
    notifyListeners();
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _selectedTheme = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  Color get containerColor {
    return _selectedTheme.brightness == Brightness.dark
        ? const Color(0xFF333333)
        : Colors.grey.shade200;
  }
}
