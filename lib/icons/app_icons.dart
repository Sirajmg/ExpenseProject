import 'package:flutter/material.dart';

class AppIcons {
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'طعام':
        return Icons.restaurant;
      case 'مواصلات':
        return Icons.directions_car;
      case 'تسوق':
        return Icons.shopping_cart;
      case 'فواتير':
        return Icons.receipt;
      case 'ترفيه':
        return Icons.movie;
      case 'صحة':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'طعام':
        return const Color(0xFF4CAF50);
      case 'مواصلات':
        return const Color(0xFF2196F3);
      case 'تسوق':
        return const Color(0xFF9C27B0);
      case 'فواتير':
        return const Color(0xFFF44336);
      case 'ترفيه':
        return const Color(0xFFFF9800);
      case 'صحة':
        return const Color(0xFFE91E63);
      default:
        return Colors.grey;
    }
  }

  static Widget categoryIcon(String category, {double size = 24.0}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getCategoryColor(category).withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        getCategoryIcon(category),
        color: getCategoryColor(category),
        size: size,
      ),
    );
  }

  static Widget animatedCategoryIcon(String category, {double size = 24.0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: categoryIcon(category, size: size),
        );
      },
    );
  }

  static Widget shimmerIcon(IconData icon, {double size = 24.0}) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            Colors.white.withAlpha(0),
            Colors.white,
            Colors.white.withAlpha(0),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Icon(icon, size: size, color: Colors.white),
    );
  }

  static Widget pulseIcon(IconData icon, {double size = 24.0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(icon, size: size),
        );
      },
    );
  }
}
