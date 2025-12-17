import 'package:flutter/material.dart';

import '../themes/dark_theme.dart';

enum AppThemeMode {light, dark}

class AppTheme with ChangeNotifier {
  final ThemeData _themeData = DarkTheme.theme;
  final AppThemeMode _mode = AppThemeMode.dark;

  ThemeData get themeData => _themeData;
  AppThemeMode get mode => _mode;
}