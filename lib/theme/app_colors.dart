
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
  
    // Shared form field colors
  static const Color hint = Color(0xFF9AA8A3);
  static const Color fieldBorder = Color(0xFFD0D9D5);
  static const Color danger = Color(0xFFB85B52);

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


  // Semi-transparent colors from the Figma design.
  // Format 0xAARRGGBB: the first two digits are the opacity
  // (00 = invisible, FF = fully opaque).
  static const Color reminderCardBackground = Color(0x29F3AD91); // peach 16%
  static const Color healthCardBackground = Color(0x47F3AD91); // peach 28%
  static const Color healthCardBorder = Color(0x7AF3AD91); // peach 48%
  static const Color photosCardBackground = Color(0x2E65BDAE); // primary 18%
  static const Color photosCardBorder = Color(0x4D65BDAE); // primary 30%
  static const Color activePetLabel = Color(0xB8263D39); // darkGreen 72%
  static const Color viewProfileBackground = Color(0xB3FFF9F1); // cream 70%
  static const Color avatarBorder = Color(0xD1FFF9F1); // cream 82%
  static const Color cardShadow = Color(0x1A263D39); // darkGreen 10%
}
