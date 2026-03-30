// 🎨 App theme configuration
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDeep,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.bgDeep,
      primary: AppColors.accentGold,
      secondary: AppColors.accentGoldL,
      error: AppColors.errorRed,
      onPrimary: AppColors.logoInner,
      onSurface: AppColors.textHigh,
    ),
    fontFamily: 'Segoe UI', // Windows-native fallback
    useMaterial3: true,
  );
}
