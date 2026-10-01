import 'package:flutter/material.dart';

enum ReadingMode {
  paged,
  continuousScroll,
}

enum ReaderThemePreset {
  oled(
    backgroundColor: Color(0xFF000000),
    textColor: Color(0xFFE6E1E5),
    name: 'OLED',
  ),
  dark(
    backgroundColor: Color(0xFF1E1E24),
    textColor: Color(0xFFE2E2E6),
    name: 'Dark',
  ),
  sepia(
    backgroundColor: Color(0xFFF4ECD8),
    textColor: Color(0xFF5B4636),
    name: 'Sepia',
  ),
  paperLight(
    backgroundColor: Color(0xFFFAF7EE),
    textColor: Color(0xFF222222),
    name: 'Paper',
  ),
  pureWhite(
    backgroundColor: Color(0xFFFFFFFF),
    textColor: Color(0xFF111111),
    name: 'White',
  );

  final Color backgroundColor;
  final Color textColor;
  final String name;

  const ReaderThemePreset({
    required this.backgroundColor,
    required this.textColor,
    required this.name,
  });
}

class ReaderSettings {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final double horizontalMargin;
  final double paragraphSpacing;
  final ReadingMode readingMode;
  final ReaderThemePreset themePreset;
  final bool volumeKeyNavigation;
  final bool keepScreenOn;

  const ReaderSettings({
    this.fontSize = 18.0,
    this.lineHeight = 1.6,
    this.fontFamily = 'Roboto',
    this.horizontalMargin = 16.0,
    this.paragraphSpacing = 12.0,
    this.readingMode = ReadingMode.continuousScroll,
    this.themePreset = ReaderThemePreset.oled,
    this.volumeKeyNavigation = true,
    this.keepScreenOn = true,
  });

  ReaderSettings copyWith({
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    double? horizontalMargin,
    double? paragraphSpacing,
    ReadingMode? readingMode,
    ReaderThemePreset? themePreset,
    bool? volumeKeyNavigation,
    bool? keepScreenOn,
  }) {
    return ReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      readingMode: readingMode ?? this.readingMode,
      themePreset: themePreset ?? this.themePreset,
      volumeKeyNavigation: volumeKeyNavigation ?? this.volumeKeyNavigation,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
    );
  }
}
