import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

/// Logo, app name, subtitle and the Light/Dark toggle at the top of Home.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
        const _ThemeToggle(),
      ],
    );
  }
}

/// Light / Dark segmented toggle.
///
/// TODO: Connect to the shared theme setting so that it actually changes
/// the app theme. For now it only switches its own selection.
class _ThemeToggle extends StatefulWidget {
  const _ThemeToggle();

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
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
          _option('Light', selected: !_isDark, onTap: () {
            setState(() => _isDark = false);
          }),
          const SizedBox(width: 2),
          _option('Dark', selected: _isDark, onTap: () {
            setState(() => _isDark = true);
          }),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.darkGreen.withValues(alpha: 0.12),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
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