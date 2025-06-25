import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Corporate Blues
  static const primaryColor = Color(0xFF003366); // Deep Blue
  static const secondaryColor = Color(0xFF00509E); // Medium Blue
  static const accentColor = Color(0xFF007ACC); // Light Blue
  static const coralColor = Color(0xFFFF5722); // Coral Accent
  static const backgroundColor = Color(0xFFF5F7FA); // Light Gray Background
  static const errorColor = Color(0xFFE53935);
  static const successColor = Color(0xFF43A047);

  // Private colors for internal use
  static const _primaryColor = primaryColor;
  static const _secondaryColor = secondaryColor;
  static const _accentColor = accentColor;
  static const _coralColor = coralColor;
  static const _backgroundColor = backgroundColor;
  static const _errorColor = errorColor;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        error: _errorColor,
        surface: _backgroundColor,
      ),
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
        displayMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
        displaySmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
        headlineMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _primaryColor,
        iconTheme: IconThemeData(color: _primaryColor),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
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
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIconColor: _primaryColor,
        suffixIconColor: _primaryColor,
        labelStyle: const TextStyle(color: Colors.black54),
        hintStyle: const TextStyle(color: Colors.black38),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _coralColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: _errorColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: Colors.white,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryColor,
        linearTrackColor: Colors.grey,
        circularTrackColor: Colors.grey,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryColor.withAlpha(25),
        labelStyle: const TextStyle(color: _primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
        selectedColor: _primaryColor,
        secondarySelectedColor: _primaryColor,
        disabledColor: Colors.grey[300],
        brightness: Brightness.light,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _primaryColor.withAlpha(230),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.all(8),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static BoxDecoration get gradientDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _primaryColor.withAlpha(25),
          Colors.white,
        ],
      ),
    );
  }

  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get buttonDecoration {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [_primaryColor, _secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: _primaryColor.withAlpha(30),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
