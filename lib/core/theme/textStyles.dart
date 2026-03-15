import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // HEADINGS
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface, // black for main text
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  // BODY
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurfaceSecondary, // lighter grey for secondary text
  );

  // BUTTONS
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  // CAPTION / SMALL TEXT
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.onPrimarySecondary, 
  );

  // ERROR / WARNING
  static const TextStyle warning = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.warning,
  );
}