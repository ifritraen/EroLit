import 'package:flutter/material.dart';

class AppTheme {
  // Brand accents
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color primaryLight = Color(0xFF7F67BE);
  static const Color primaryDark = Color(0xFF4F378B);

  // Background colors
  static const Color oledBlack = Color(0xFF000000);
  static const Color surfaceOled = Color(0xFF0A0A0A);
  static const Color cardOled = Color(0xFF141414);

  // Reader paper backgrounds
  static const Color paperLight = Color(0xFFFAF7EE);
  static const Color paperSepia = Color(0xFFF4ECD8);
  static const Color paperTextSepia = Color(0xFF5B4636);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF9F9FB),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: primaryColor.withValues(alpha: 0.15),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121214),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: primaryColor.withValues(alpha: 0.3),
    ),
  );

  static ThemeData oledTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD0BCFF),
      onPrimary: Color(0xFF381E72),
      secondary: Color(0xFFCCC2DC),
      surface: surfaceOled,
      onSurface: Color(0xFFE6E1E5),
    ),
    scaffoldBackgroundColor: oledBlack,
    cardColor: cardOled,
    appBarTheme: const AppBarTheme(
      backgroundColor: oledBlack,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: oledBlack,
      elevation: 0,
      indicatorColor: const Color(0xFF4F378B),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
