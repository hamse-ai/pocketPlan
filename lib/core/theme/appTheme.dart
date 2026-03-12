import 'package:flutter/material.dart';
import 'colors.dart';
import 'textStyles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.onSurface),
      iconTheme: IconThemeData(color: AppColors.iconActive),
      centerTitle: true,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: AppColors.iconActive,
      unselectedItemColor: AppColors.iconInactive,
    ),

    iconTheme: const IconThemeData(
      color: AppColors.iconActive,
    ),

    textTheme: const TextTheme(
      displayLarge: AppTextStyles.heading1,
      displayMedium: AppTextStyles.heading2,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodySecondary,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        textStyle: AppTextStyles.button,
      ),
    ),

    disabledColor: AppColors.disabled,
  );
}