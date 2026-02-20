import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevent instantiation

  /// **Primary Color** (Brand/Accent)
  /// - Main brand color for buttons, app bar, primary actions
  /// - Example: ElevatedButton background, AppBar background
  static const Color primary = Color(0xFFCA5049);     // Vibrant Blue

  /// **Secondary Color** (Supporting Accent)
  /// - Success states, secondary buttons, highlights
  /// - Example: Success snackbars, floating action button
  static const Color secondary = Color(0xFFCA5049);   // Fresh Green

  /// **Background Color** (App-wide Background)
  /// - Main scaffold/background of entire app screens
  /// - Example: Scaffold(backgroundColor: AppColors.background)
  static const Color background = Color(0xFFFFFFFF);  // Light Gray-Blue

  /// **Surface Color** (Cards/Panels)
  /// - Elevated containers, cards, dialogs, sheets
  /// - Example: Card(color: AppColors.surface), bottom sheets
  static const Color surface = Color(0xFFFFFFFF);     // Pure White

  /// **Text Primary** (Main Content Text)
  /// - Primary body text, headings, important labels
  /// - Example: Text('Hello', style: TextStyle(color: AppColors.textPrimary))
  static const Color textPrimary = Color(0xFF1A1A1A); // Dark Gray-Black

  /// **Text Secondary** (Supporting Text)
  /// - Subtitles, hints, secondary labels, timestamps
  /// - Example: Text('Yesterday', style: TextStyle(color: AppColors.textSecondary))
  static const Color textSecondary = Color(0xFF6B7280); // Medium Gray

  /// **Error Color** (Errors/Warnings)
  /// - Error messages, validation errors, destructive actions
  /// - Example: Error text, invalid input borders
  static const Color error = Color(0xFFEF4444);       // Bright Red

  /// **Border Color** (Dividers/Borders)
  /// - Container borders, dividers, focused input borders
  /// - Example: Divider(color: AppColors.border), input outlines
  static const Color border = Color(0xFFE5E7EB);      // Light Gray
}
