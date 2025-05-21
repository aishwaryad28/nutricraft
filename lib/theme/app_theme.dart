import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Color palette as specified
  static const softMint = Color(0xFFDFFFE0);
  static const pastelPeach = Color(0xFFFFD6C0);
  static const lightLavender = Color(0xFFE6D6FF);
  static const blushPink = Color(0xFFFFE3E3);
  static const skyBlue = Color(0xFFC0EFFF);
  static const charcoalGray = Color(0xFF333333);
  static const pastelGreen = Color(0xFFCFFFCF);
  static const lightApricot = Color(0xFFFFE6B2);
  
  // Additional colors
  static const white = Colors.white;
  static const black = Colors.black;
  static const transparent = Colors.transparent;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.pastelPeach,
      scaffoldBackgroundColor: AppColors.softMint,
      colorScheme: ColorScheme.light(
        primary: AppColors.pastelPeach,
        secondary: AppColors.lightLavender,
        background: AppColors.softMint,
        surface: AppColors.white,
        onPrimary: AppColors.charcoalGray,
        onSecondary: AppColors.charcoalGray,
        onBackground: AppColors.charcoalGray,
        onSurface: AppColors.charcoalGray,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: AppColors.charcoalGray),
          displayMedium: TextStyle(color: AppColors.charcoalGray),
          displaySmall: TextStyle(color: AppColors.charcoalGray),
          headlineMedium: TextStyle(color: AppColors.charcoalGray),
          headlineSmall: TextStyle(color: AppColors.charcoalGray),
          titleLarge: TextStyle(color: AppColors.charcoalGray),
          bodyLarge: TextStyle(color: AppColors.charcoalGray),
          bodyMedium: TextStyle(color: AppColors.charcoalGray),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.softMint,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.charcoalGray),
        titleTextStyle: GoogleFonts.nunito(
          color: AppColors.charcoalGray,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pastelPeach,
          foregroundColor: AppColors.charcoalGray,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.pastelPeach,
          side: BorderSide(color: AppColors.pastelPeach),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.pastelPeach,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.pastelPeach, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(
          color: AppColors.charcoalGray.withOpacity(0.5),
          fontSize: 16,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.pastelPeach,
        unselectedItemColor: AppColors.charcoalGray.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
