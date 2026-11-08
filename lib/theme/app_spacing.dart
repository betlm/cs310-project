import 'package:flutter/material.dart';

/// Shared spacing and corner radius values.
class AppSpacing {
  AppSpacing._();

  // Spacing values
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Corner radius values
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 20;

  // Common screen padding
  static const EdgeInsets screenPadding =
      EdgeInsets.all(lg);
}
