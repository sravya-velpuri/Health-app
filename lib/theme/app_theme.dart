import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color accentGreen = Color(0xFF00FF87);
  static const Color accentBlue = Color(0xFF60EFFF);
  static const Color darkBackground = Color(0xFF0B101E);
  static const Color lightBackground = Color(0xFFE9F0FB);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentBlue,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentGreen,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
    );
  }
}
