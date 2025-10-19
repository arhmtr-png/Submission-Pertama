import 'package:flutter/material.dart';

/// A compact definition of common Material text styles mapped to the
/// application's design system. These correspond to the typical
/// 15-material-type-token set (headlineLarge, headlineMedium, headlineSmall,
/// titleLarge, titleMedium, titleSmall, bodyLarge, bodyMedium, bodySmall,
/// labelLarge, labelMedium, labelSmall, displayLarge, displayMedium, displaySmall).
class TourismTextStyles {
  static TextTheme build(TextTheme base) => base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 57,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),

    headlineLarge: base.headlineLarge?.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),

    titleLarge: base.titleLarge?.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: base.titleSmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),

    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),

    labelLarge: base.labelLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: base.labelSmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
  );
}
