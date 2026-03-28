import 'package:flutter/material.dart';

class AppColorsDark {
  // Primary colors
  static const Color primary = Color(0xFF00A0A0); // Lighter teal for dark mode
  static const Color onPrimary = Color(0xFF000000); // Black text on primary
  static const Color onPrimarySecondary = Color(0xFF333333); // Dark grey for secondary text on primary
  
  // Background and surface colors
  static const Color background = Color(0xFF121212); // Dark background
  static const Color surface = Color(0xFF1E1E1E); // Slightly lighter for cards
  static const Color onSurface = Color(0xFFE0E0E0); // Light text on dark surface
  static const Color onSurfaceSecondary = Color(0xFF9E9E9E); // Grey for secondary text
  
  // UI element colors
  static const Color disabled = Color(0xFF616161); // Disabled elements
  static const Color iconInactive = Color(0xFF757575); // Inactive navigation icons
  static const Color iconActive = Color(0xFFE0E0E0); // Active navigation icons
  
  // Status colors
  static const Color warning = Color(0xFFEF5350); // Warning/error red
  static const Color onWarning = Color(0xFFFFFFFF); // Text on warning
  static const Color onWarningSecondary = Color(0xFFE0E0E0); // Secondary text on warning
  static const Color delete = Color(0xFFD32F2F); // Delete action red
  static const Color onDelete = Color(0xFFFFFFFF); // Text on delete button
}