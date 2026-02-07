import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Mawduuca App-ka (App Theme)
class AppTheme {
  // Midabada ugu muhiimsan (Two Main Colors)
  static const Color primaryColor = Color(0xFF673AB7); // Deep Purple
  static const Color secondaryColor = Color(0xFFFFD700); // Gold
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.black;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
