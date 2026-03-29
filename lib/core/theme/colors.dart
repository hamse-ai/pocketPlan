import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF006B5F); // Teal primary color
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color onPrimarySecondary = Color(0xFFE0E0E0); // Light grey for secondary text on primary
  
  // Background and surface colors
  static const Color background = Color(0xFFF5F5F5); // Light background
  static const Color surface = Color(0xFFFFFFFF); // White for cards
  static const Color onSurface = Color(0xFF212121); // Dark text on light surface
  static const Color onSurfaceSecondary = Color(0xFF757575); // Grey for secondary text
  
  // UI element colors
  static const Color disabled = Color(0xFFBDBDBD); // Disabled elements
  static const Color iconInactive = Color(0xFF9E9E9E); // Inactive navigation icons
  static const Color iconActive = Color(0xFF006B5F); // Active navigation icons (primary color)
  
  // Status colors
  static const Color warning = Color(0xFFEF5350); // Warning/error red
  static const Color onWarning = Color(0xFFFFFFFF); // Text on warning
  static const Color onWarningSecondary = Color(0xFF212121); // Secondary text on warning
  static const Color delete = Color(0xFFD32F2F); // Delete action red
  static const Color onDelete = Color(0xFFFFFFFF); // Text on delete button
}