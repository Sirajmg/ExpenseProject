import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../icons/app_icons.dart';

class AppStyles {
  static TextStyle get title => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      );

  static TextStyle get subtitle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppTheme.secondaryColor,
      );

  static TextStyle get body => const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      );

  static TextStyle get caption => const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      );

  static TextStyle get amount => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      );

  static TextStyle get category => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.secondaryColor,
      );

  static TextStyle get date => const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      );

  static TextStyle get error => const TextStyle(
        fontSize: 14,
        color: AppTheme.errorColor,
      );

  static TextStyle get success => const TextStyle(
        fontSize: 14,
        color: AppTheme.successColor,
      );

  static InputDecoration inputDecoration({
    required String label,
    IconData? prefixIcon,
    String? suffixText,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixText: suffixText,
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
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static BoxDecoration cardDecoration({
    Color? color,
    double elevation = 2,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: elevation * 2,
          offset: Offset(0, elevation),
        ),
      ],
    );
  }

  static BoxDecoration gradientDecoration({
    Color? startColor,
    Color? endColor,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          startColor ?? AppTheme.primaryColor.withAlpha(25),
          endColor ?? Colors.white,
        ],
      ),
    );
  }

  static BoxDecoration buttonDecoration({
    Color? startColor,
    Color? endColor,
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          startColor ?? AppTheme.primaryColor,
          endColor ?? AppTheme.secondaryColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: (startColor ?? AppTheme.primaryColor).withAlpha(25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration categoryDecoration(String category) {
    return BoxDecoration(
      color: AppIcons.getCategoryColor(category).withAlpha(25),
      borderRadius: BorderRadius.circular(8),
    );
  }

  static BoxDecoration progressDecoration({
    Color? color,
    double borderRadius = 4,
  }) {
    return BoxDecoration(
      color: color ?? Colors.grey[200],
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static BoxDecoration summaryCardDecoration({
    Color? color,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primaryColor.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: AppTheme.primaryColor.withOpacity(0.1),
        width: 1,
      ),
    );
  }

  static BoxDecoration chartCardDecoration({
    Color? color,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primaryColor.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration alertDecoration({
    Color? color,
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      color: color ?? AppTheme.errorColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppTheme.errorColor.withOpacity(0.2),
        width: 1,
      ),
    );
  }
}
