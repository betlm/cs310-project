import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Shown in a list screen when there is nothing to show yet
/// a big icon, a title, a message and an optional button
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  /// Text of the button - if null, no button is shown
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      CircleAvatar(
        radius: 44,
        backgroundColor: AppColors.lightMint,
        child: Icon(icon, size: 44, color: AppColors.primary),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyles.headingSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ];

    // Add the button only if the screen gave one
    if (buttonText != null && onButtonPressed != null) {
      children.add(const SizedBox(height: AppSpacing.lg));
      children.add(
        ElevatedButton.icon(
          onPressed: onButtonPressed,
          icon: const Icon(Icons.add),
          label: Text(
            buttonText!,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.darkGreen,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}