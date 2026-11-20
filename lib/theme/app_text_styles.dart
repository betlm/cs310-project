
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Shared text styles used throughout the PetPocket app.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headingLarge => TextStyle(
    fontFamily: 'Manrope',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGreen,
  );

  static TextStyle get headingMedium => TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGreen,
  );

  static TextStyle get headingSmall => TextStyle(
    fontFamily: 'Manrope',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGreen,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 16,
    color: AppColors.darkGreen,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 14,
    color: AppColors.secondaryText,
  );

  static TextStyle get caption => TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 12,
    color: AppColors.secondaryText,
  );

  static TextStyle get button => TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}
