import 'package:flutter/material.dart';

import '../../../data/app_state.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../main_shell.dart';

/// The 2x2 grid of summary cards on Home:
/// Health, Supplies, Photos and Reminders for the active pet.
class SummaryGrid extends StatelessWidget {
  final String petId;

  const SummaryGrid({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final healthCount = healthRecordsFor(petId).length;
    final pendingSupplies = pendingSupplyCount(petId);
    final photoCount = photosFor(petId).length;
    final activeReminders =
        remindersFor(petId).where((r) => !r.isCompleted).length;

    const gap = AppSpacing.sm + 2; // 10

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
                backgroundColor: AppColors.peach.withValues(alpha: 0.28),
                borderColor: AppColors.peach.withValues(alpha: 0.48),
                // Health is a bottom navigation tab, so switch to it.
                onTap: () => MainShell.switchTab(context, 1),
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
                onTap: () => Navigator.pushNamed(context, AppRoutes.supplies),
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
                backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                borderColor: AppColors.primary.withValues(alpha: 0.3),
                onTap: () => Navigator.pushNamed(context, AppRoutes.photos),
              ),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: SummaryCard(
                icon: Icons.calendar_today_outlined,
                title: 'Reminders',
                subtitle: '$activeReminders active',
                iconColor: AppColors.primary,
                // Cream, same tone as the page background.
                backgroundColor: AppColors.background,
                borderColor: AppColors.creamBorder,
                onTap: () => Navigator.pushNamed(context, AppRoutes.reminders),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// "1 record" / "4 records".
  static String _plural(int count, String one, String many) =>
      '$count ${count == 1 ? one : many}';
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
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(15);

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md - 2, // 14
            horizontal: AppSpacing.sm,
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
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
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}