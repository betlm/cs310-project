import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../data/app_state.dart';

/// Logo, app name, subtitle and the Light/Dark toggle at the top of Home.
class HomeHeader extends StatelessWidget {
  /// Tells MainShell that Light or Dark was chosen.
  final VoidCallback onAppearanceChanged;

  const HomeHeader({super.key, required this.onAppearanceChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Image.asset('assets/images/logo.png', width: 52, height: 52),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs), // 12
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PetPocket',
                style: textTheme.headlineLarge?.copyWith(
                  fontSize: 30,
                  height: 1.1,
                ),
              ),
              Text(
                'Pet Care & Tracking App',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        _ThemeToggle(onChanged: onAppearanceChanged),
      ],
    );
  }
}

/// Light / Dark segmented toggle. Uses the same setting as Preferences so both always show the same choice.
class _ThemeToggle extends StatelessWidget {
  final VoidCallback onChanged;

  const _ThemeToggle({required this.onChanged});

  /// Saves the choice and asks MainShell to apply it.
  void _select(String value) {
    appAppearance = value;
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode();
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.lightMint,
        border: Border.all(color: AppColors.mintBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _option('Light', selected: !isDark, onTap: () => _select('light')),
          const SizedBox(width: 2),
          _option('Dark', selected: isDark, onTap: () => _select('dark')),
        ],
      ),
    );
  }

  /// One side of the toggle; the selected side gets a cream background
  /// and a small shadow.
  Widget _option(
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected
              ?  [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 7,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: selected ? AppColors.darkGreen : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}