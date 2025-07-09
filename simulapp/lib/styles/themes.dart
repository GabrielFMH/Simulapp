import 'package:flutter/material.dart';

import 'colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: MyColors.blue,
    fontFamily: 'Commissioner',
    appBarTheme: const AppBarTheme(
      backgroundColor: MyColors.blue,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.blue,
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: MyColors.blue,
    fontFamily: 'Commissioner',
    scaffoldBackgroundColor: MyColors.backgroundDark,
  );
}