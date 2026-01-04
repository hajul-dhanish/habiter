import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFF6200EE);
  static const Color sidebarBackground = Color(0xFFF5F5F7);
  static const Color mainBackground = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFAFAFA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        primary: primaryColor,
        surface: surfaceColor,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: mainBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
        primary: Colors.white,
        surface: const Color(0xFF1C1C1E),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: const Color(0xFF000000),
    );
  }
}
