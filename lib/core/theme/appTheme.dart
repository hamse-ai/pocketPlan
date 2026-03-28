import 'package:flutter/material.dart';
import 'colors.dart';
import 'colors_dark.dart';
import 'textStyles.dart';

class AppTheme {
  // ── Light Theme ──────────────────────────────────────────────────────────────
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.warning,
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

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.onPrimary;
        }
        return AppColors.disabled;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surface;
      }),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    disabledColor: AppColors.disabled,
  );

  // ── Dark Theme ───────────────────────────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColorsDark.primary,
    scaffoldBackgroundColor: AppColorsDark.background,
    colorScheme: ColorScheme.dark(
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,
      error: AppColorsDark.warning,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading2.copyWith(
        color: AppColorsDark.onSurface,
      ),
      iconTheme: IconThemeData(color: AppColorsDark.iconActive),
      centerTitle: true,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: AppColorsDark.iconActive,
      unselectedItemColor: AppColorsDark.iconInactive,
    ),

    iconTheme: const IconThemeData(
      color: AppColorsDark.iconActive,
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(
        color: AppColorsDark.onSurface,
      ),
      displayMedium: AppTextStyles.heading2.copyWith(
        color: AppColorsDark.onSurface,
      ),
      bodyLarge: AppTextStyles.body.copyWith(
        color: AppColorsDark.onSurface,
      ),
      bodyMedium: AppTextStyles.bodySecondary.copyWith(
        color: AppColorsDark.onSurfaceSecondary,
      ),
      bodySmall: AppTextStyles.caption.copyWith(
        color: AppColorsDark.onPrimarySecondary,
      ),
      labelLarge: AppTextStyles.button.copyWith(
        color: AppColorsDark.onPrimary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark.primary,
        foregroundColor: AppColorsDark.onPrimary,
        textStyle: AppTextStyles.button,
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.onPrimary;
        }
        return AppColorsDark.disabled;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.primary;
        }
        return AppColorsDark.surface;
      }),
    ),

    cardTheme: CardThemeData(
      color: AppColorsDark.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    disabledColor: AppColorsDark.disabled,
  );

  // ── Theme Helper ─────────────────────────────────────────────────────────────
  
  /// Returns appropriate theme based on theme setting
  static ThemeData getTheme(String themeSetting) {
    switch (themeSetting) {
      case 'Dark':
        return darkTheme;
      case 'Light':
        return lightTheme;
      case 'System Default':
        // Will be handled by MaterialApp's themeMode
        return lightTheme;
      default:
        return lightTheme;
    }
  }

  /// Returns ThemeMode based on theme setting
  static ThemeMode getThemeMode(String themeSetting) {
    switch (themeSetting) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      case 'System Default':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}