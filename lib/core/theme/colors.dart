import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF006060); // For buttons
  static const Color onPrimary = Color(0xFFFFFFFF); // For text on primary color
  static const Color onPrimarySecondary = Color(0xFFD9D9D9,); // For secondary text on primary color
  static const Color background = Color(0xFFFFFFFF); // For app background
  static const Color surface = Color(0xFFD9D9D9,); // For cards and surfaces background

  // STATES
  static const Color disabled = Color(0xFF737171); // For disabled toggle

  // ICONS / NAVIGATION
  static const Color iconInactive = Color(0xFFCCCCCC,); // For inactive icons on the bottom navigation bar
  static const Color iconActive = Color(0xFF222222,); // For active icons on the bottom navigation bar

  // FEEDBACK
  static const Color warning = Color(0xFFE57373); // For warning messages
  static const Color onWarning = Color(0xFFFFFFFF); // For text on warning messages
  static const Color onWarningSecondary = Color(0xFFDBDBDB); // For secondary text on warning messages
  static const Color delete = Color(0xFFD32F2F); // For delete actions
  static const Color onDelete = Color(0xFFFFFFFF); // For text on delete actions 
}
