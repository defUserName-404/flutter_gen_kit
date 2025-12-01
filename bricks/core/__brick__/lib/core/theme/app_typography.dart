import 'package:flutter/material.dart';

class AppTypography {
  static TextTheme lightTextTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.normal),
    displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.normal),
    displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.normal),
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal),
    headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.normal),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
    titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal),
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
  );

  static TextTheme darkTextTheme = lightTextTheme; // Often same or slightly adjusted
}
