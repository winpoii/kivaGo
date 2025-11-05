import 'package:flutter/material.dart';

/// App theme configuration with Material 3 design
/// Brand colors: vibrant and modern
class AppTheme {
  // Brand color palette
  static const Color primary = Color(0xFFC11336); // red
  static const Color secondary = Color(0xFFCD5970); // pink
  static const Color accent = Color(0xFFF56F29); // orange
  static const Color yellow = Color(0xFFF3E602); // yellow
  static const Color surface = Color(0xFFFDFDFD); // white
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      surface: surface,
      onPrimary: onPrimary,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
    ),

    // Typography with increased letter spacing for headings
    textTheme: const TextTheme(
      headlineLarge: TextStyle(letterSpacing: 0.5),
      headlineMedium: TextStyle(letterSpacing: 0.5),
      headlineSmall: TextStyle(letterSpacing: 0.5),
      titleLarge: TextStyle(letterSpacing: 0.3),
      titleMedium: TextStyle(letterSpacing: 0.3),
      titleSmall: TextStyle(letterSpacing: 0.3),
    ),

    // Card theme with rounded corners and soft shadows
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: surface,
      foregroundColor: Colors.black87,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: secondary.withOpacity(0.2),
      labelStyle: const TextStyle(color: Colors.black87),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );

  // Dark theme (auto-derived from light theme)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      surface: const Color(0xFF1A1A1A),
      onPrimary: onPrimary,
      onSecondary: Colors.white,
      onSurface: Colors.white70,
    ),

    // Typography with increased letter spacing for headings
    textTheme: const TextTheme(
      headlineLarge: TextStyle(letterSpacing: 0.5),
      headlineMedium: TextStyle(letterSpacing: 0.5),
      headlineSmall: TextStyle(letterSpacing: 0.5),
      titleLarge: TextStyle(letterSpacing: 0.3),
      titleMedium: TextStyle(letterSpacing: 0.3),
      titleSmall: TextStyle(letterSpacing: 0.3),
    ),

    // Card theme with rounded corners and soft shadows
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF2A2A2A),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white70,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: secondary.withOpacity(0.3),
      labelStyle: const TextStyle(color: Colors.white70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}
