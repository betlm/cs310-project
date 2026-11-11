import 'package:flutter/material.dart';

import '../../../models/reminder.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/date_format.dart';

/// "Upcoming Reminders" title with a "See all" link and a card
/// for the next reminder of the active pet.
class UpcomingReminderSection extends StatelessWidget {
  /// The next reminder, or null if the pet has none.
  final Reminder? reminder;

  const UpcomingReminderSection({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Upcoming Reminders', style: textTheme.titleLarge),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.reminders),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('See all'),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (reminder == null)
          Text('No upcoming reminders', style: textTheme.bodyMedium)
        else
          _ReminderTile(reminder: reminder!),
      ],
    );
  }
}

/// Peach card with the reminder's icon, title, date and time.
class _ReminderTile extends StatelessWidget {
  final Reminder reminder;

  const _ReminderTile({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppSpacing.radiusLarge);

    return Material(
      color: AppColors.peach.withValues(alpha: 0.25),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () => Navigator.pushNamed(context, AppRoutes.reminders),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.white,
                child: Icon(_iconFor(reminder.category),
                    color: AppColors.peach),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 14, color: AppColors.secondaryText),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          _whenText(reminder),
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.darkGreen),
            ],
          ),
        ),
      ),
    );
  }

  /// "10/11/2026 · 10:00" for one-time reminders "Daily · 19:00" for daily
  static String _whenText(Reminder r) {
    final time = formatTime(r.hour, r.minute);
    if (r.repeat == RepeatType.daily || r.date == null) {
      return 'Daily · $time';
    }
    return '${formatDate(r.date!)} · $time';
  }

  /// A different icon for each reminder category.
  static IconData _iconFor(ReminderCategory category) => switch (category) {
        ReminderCategory.medication => Icons.medication_outlined,
        ReminderCategory.appointment => Icons.notifications_none,
        ReminderCategory.feeding => Icons.restaurant_outlined,
        ReminderCategory.other => Icons.notifications_none,
      };
}