import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    accentColor: Colors.blue[900],
    scaffoldBackgroundColor: Colors.white);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  accentColor: Colors.blue[900],
  scaffoldBackgroundColor: Colors.grey[900],
);

class ThemeNotifier extends ChangeNotifier {
  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref.setBool(key, _darkTheme);
  }

  final String key = "theme";
  SharedPreferences _pref;
  bool _darkTheme;
  bool get darkTheme => _darkTheme;
  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }
  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }
}
