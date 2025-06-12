import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blue.shade800,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue.shade600,
        backgroundColor: Colors.white,
      ).copyWith(
        secondary: Colors.blue.shade600,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme.copyWith(
          headlineLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade900,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade800,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 4,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}