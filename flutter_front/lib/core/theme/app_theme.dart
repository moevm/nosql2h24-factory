import 'package:flutter/material.dart';

abstract class AppTheme {
  Color get primaryColor;
  Color get scaffoldBackgroundColor;
  Color get appBarBackgroundColor;
  Color get appBarForegroundColor;
  Color get cardColor;
  Color get cardShadowColor;
  Brightness get brightness;
}

abstract class BaseTheme implements AppTheme {
  ThemeData get themeData => ThemeData(
    primaryColor: primaryColor,
    primarySwatch: Colors.blue,
    brightness: brightness,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: appBarBackgroundColor,
      foregroundColor: appBarForegroundColor,
    ),
    cardTheme: CardTheme(
      color: cardColor,
      shadowColor: cardShadowColor,
    ),
  );
}

class LightTheme extends BaseTheme {
  @override
  Color get primaryColor => const Color(0xFF6750A4);

  @override
  Color get scaffoldBackgroundColor => Colors.white;

  @override
  Color get appBarBackgroundColor => const Color(0xFF6750A4).withOpacity(0.7);

  @override
  Color get appBarForegroundColor => Colors.white;

  @override
  Color get cardColor => Colors.grey[300]!;

  @override
  Color get cardShadowColor => Colors.black.withOpacity(0.2);

  @override
  Brightness get brightness => Brightness.light;
}

class DarkTheme extends BaseTheme {
  @override
  Color get primaryColor => const Color(0xFF6750A4);

  @override
  Color get scaffoldBackgroundColor => Colors.grey[900]!;

  @override
  Color get appBarBackgroundColor => Colors.grey[800]!;

  @override
  Color get appBarForegroundColor => Colors.white;

  @override
  Color get cardColor => Colors.grey[800]!;

  @override
  Color get cardShadowColor => Colors.black.withOpacity(0.3);

  @override
  Brightness get brightness => Brightness.dark;
}