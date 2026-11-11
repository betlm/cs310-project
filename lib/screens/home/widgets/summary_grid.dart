import 'package:flutter/material.dart';

import '../../../data/app_state.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

/// The 2x2 grid of summary cards on Home:
/// Health, Supplies, Photos and Reminders for the active pet.
class SummaryGrid extends StatelessWidget {
  final String petId;

  /// Switches to the Health tab.
  final VoidCallback onOpenHealth;

  /// Opens a screen by its route name.
  final void Function(String routeName) onOpenScreen;

  const SummaryGrid({
    super.key,
    required this.petId,
    required this.onOpenHealth,
    required this.onOpenScreen,
  });

  @override
  Widget build(BuildContext context) {
    final healthCount = healthRecordsFor(petId).length;
    final pendingSupplies = pendingSupplyCount(petId);
    final photoCount = photosFor(petId).length;
    final activeReminders = remindersFor(petId).where(isUpcoming).length;

    const gap = 10.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.favorite_border,
                title: 'Health',
                subtitle: _plural(healthCount, 'record', 'records'),
                iconColor: AppColors.peach,
                backgroundColor: AppColors.healthCardBackground,
                borderColor: AppColors.healthCardBorder,
                onTap: onOpenHealth,
              ),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: SummaryCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Supplies',
                subtitle: '$pendingSupplies pending',
                iconColor: AppColors.primary,
                backgroundColor: AppColors.lightMint,
                borderColor: AppColors.mintBorder,
                onTap: () => onOpenScreen(AppRoutes.supplies),
              ),
            ),
          ],
        ),
        const SizedBox(height: gap),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.image_outlined,
                title: 'Photos',
                subtitle: _plural(photoCount, 'photo', 'photos'),
                iconColor: AppColors.primary,
                backgroundColor: AppColors.photosCardBackground,
                borderColor: AppColors.photosCardBorder,
                onTap: () => onOpenScreen(AppRoutes.photos),
              ),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: SummaryCard(
                icon: Icons.calendar_today_outlined,
                title: 'Reminders',
                subtitle: '$activeReminders active',
                iconColor: AppColors.primary,
                // Cream, the same tone as the page background.
                backgroundColor: AppColors.background,
                borderColor: AppColors.creamBorder,
                onTap: () => onOpenScreen(AppRoutes.reminders),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// "1 record" / "4 records".
  static String _plural(int count, String one, String many) {
    if (count == 1) {
      return '$count $one';
    }
    return '$count $many';
  }
}

/// A single tappable summary card with an icon, a title and a count.
class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: AppColors.darkGreen,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}