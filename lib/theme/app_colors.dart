
import 'package:flutter/material.dart';
import '../data/app_state.dart';

/// Shared colors used throughout the PetPocket app.
class AppColors {
  AppColors._();

  // ---------- Same in light and dark ----------

  static const Color primary = Color(0xFF65BDAE);
  static const Color peach = Color(0xFFF3AD91);
  static const Color danger = Color(0xFFB85B52);
  static const Color mint = primary;

  /// Dark green that never changes. Used for text and icons on top of
  /// light colored boxes (active pet card, species avatars, category icons),
  /// which stay light in dark mode too.
  static const Color ink = Color(0xFF263D39);

  // Reminder card icon
  static const Color reminderIcon = Color(0xFFF08E70);

  // Species colors: avatar backgrounds and the active pet card on Home
  static const Color speciesCat = Color(0xFFB8E0D2);
  static const Color speciesDog = Color(0xFFF4E2D0);
  static const Color speciesBird = Color(0xFFD3E4C3);
  static const Color speciesFish = Color(0xFFF4C4B2);
  static const Color speciesRabbit = Color(0xFFB8D5D8);
  static const Color speciesHamster = Color(0xFFD3C1E2);

  // Semi-transparent colors
  // Format 0xAARRGGBB: the first two digits are the opacity
  // (00 = invisible, FF = fully opaque).
  static Color get reminderCardBackground => isDarkMode() ? const Color(0xFF304A45) : const Color(0x29F3AD91);
  static Color get healthCardBackground => isDarkMode() ? const Color(0xFF304A45) : const Color(0x47F3AD91);
  static Color get healthCardBorder => isDarkMode() ? const Color(0xFF3D5A54) : const Color(0x7AF3AD91);
  static const Color photosCardBackground = Color(0x2E65BDAE); // primary 18%
  static const Color photosCardBorder = Color(0x4D65BDAE); // primary 30%
  static const Color viewProfileBackground = Color(0xB3FFF9F1); // cream 70%
  static const Color avatarBorder = Color(0xD1FFF9F1); // cream 82%
  static const Color navBackgroundDark = Color(0xFF1E332F);

  // ---------- Change in dark mode ----------
  // Format: dark value first, light value second.

  /// Screen background.
  static Color get background =>
      isDarkMode() ? const Color(0xFF263D39) : const Color(0xFFFFF9F1);
  static Color get cream => background;

  /// Top bars (AppBar, Home header). Darker than the screen in dark mode,
  /// same as the bottom bar.
  static Color get appBar =>
      isDarkMode() ? const Color(0xFF1E332F) : const Color(0xFFFFFFFF);

  static Color get homeHeader =>
      isDarkMode() ? const Color(0xFF1E332F) : const Color(0xFFFFF9F1);

  /// Bottom navigation bar.
  static Color get navBackground =>
      isDarkMode() ? const Color(0xFF1E332F) : const Color(0xFFFFFFFF);

  /// Cards and boxes. Named "white" because it is white in light mode.
  static Color get white =>
      isDarkMode() ? const Color(0xFF304A45) : const Color(0xFFFFFFFF);

  /// Main text and icon color.
  static Color get darkGreen =>
      isDarkMode() ? const Color(0xFFFFF9F1) : const Color(0xFF263D39);

  static Color get secondaryText =>
      isDarkMode() ? const Color(0xFFBEC1BA) : const Color(0xFF647A74);

  static Color get lightMint =>
      isDarkMode() ? const Color(0xFF3B5B54) : const Color(0xFFE9F7F2);

  static Color get dangerLight =>
      isDarkMode() ? const Color(0xFF4A3A36) : const Color(0xFFFFF0E8);

  // Shared form field colors
  static Color get hint =>
      isDarkMode() ? const Color(0xFF93A09B) : const Color(0xFF9AA8A3);
  static Color get fieldBorder =>
      isDarkMode() ? const Color(0xFF4A6862) : const Color(0xFFD0D9D5);

  // Borders
  static Color get creamBorder =>
      isDarkMode() ? const Color(0xFF3D5A54) : const Color(0xFFEADFD3);
  static Color get mintBorder =>
      isDarkMode() ? const Color(0xFF3F6159) : const Color(0xFFCDE9E1);
  static Color get weightCardBorder =>
      isDarkMode() ? const Color(0xFF3F6159) : const Color(0xFFBFE1D9);
  static Color get cardBorder =>
      isDarkMode() ? const Color(0xFF3D5A54) : const Color(0xFFE3E6E4);
  static Color get dashedBorder =>
      isDarkMode() ? const Color(0xFF5C7A73) : const Color(0xFFC4CBC8);

  // Bottom navigation bar
  static Color get navInactive =>
      isDarkMode() ? const Color(0xFFA9B5B0) : const Color(0xFF89938F);
  static Color get navBorder =>
      isDarkMode() ? const Color(0xFF2E4641) : const Color(0xFFE0E4E0);

  /// "ACTIVE PET" label on the mint card: fully dark in dark mode
  /// so it is easy to read.
  static Color get activePetLabel =>
      isDarkMode() ? const Color(0xFF263D39) : const Color(0xB8263D39);

  static Color get cardShadow =>
      isDarkMode() ? const Color(0x33000000) : const Color(0x1A263D39);
}