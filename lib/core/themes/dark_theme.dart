import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: "Inter",
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xff121212),
      primaryColor: Color(0xff7e57c2),
      hintColor: Color(0x80ffffff),
      colorScheme: ColorScheme.dark(
        primary: Color(0xff7e57c2),
        secondary: Color(0xffb388ff),
        error: Color(0xff990000),
        onError: Color(0xffcc0000),
        onSurface: Color(0xffffffff)
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff151515),
        foregroundColor: Color(0xffffffff),
        elevation: 0
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: const Color(0xff121212),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0x80ffffff)
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff7e57c2)
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff7e57c2)
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffb388ff),
            width: 2
          )
        )
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff7e57c2),
          foregroundColor: Color(0xffffffff)
        )
      )
    );
  }
}