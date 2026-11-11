
import 'package:flutter/material.dart';

/// Shared colors used throughout the PetPocket app.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF65BDAE);
  static const Color darkGreen = Color(0xFF263D39);
  static const Color background = Color(0xFFFFF9F1);
  static const Color lightMint = Color(0xFFE9F7F2);
  static const Color secondaryText = Color(0xFF647A74);
  static const Color peach = Color(0xFFF3AD91);
  static const Color white = Color(0xFFFFFFFF);

  // Compatibility aliases for existing theme code.
  static const Color mint = primary;
  static const Color cream = background;


  // Borders
  static const Color creamBorder = Color(0xFFEADFD3);
  static const Color mintBorder = Color(0xFFCDE9E1);
  static const Color weightCardBorder = Color(0xFFBFE1D9);

  // Reminder card
  static const Color reminderIcon = Color(0xFFF08E70);

  // Bottom navigation bar
  static const Color navInactive = Color(0xFF89938F);
  static const Color navBorder = Color(0xFFE0E4E0);
  static const Color navBackgroundDark = Color(0xFF1E332F);

  // Species colors: avatar backgrounds and the active pet card on Home.
  static const Color speciesCat = Color(0xFFB8E0D2);
  static const Color speciesDog = Color(0xFFF4E2D0);
  static const Color speciesBird = Color(0xFFD3E4C3);
  static const Color speciesFish = Color(0xFFF4C4B2);
  static const Color speciesRabbit = Color(0xFFB8D5D8);
  static const Color speciesHamster = Color(0xFFD3C1E2);
}
