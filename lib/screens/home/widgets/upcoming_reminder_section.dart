import 'package:flutter/material.dart';

import '../../../models/reminder.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/date_format.dart';

/// "Upcoming Reminders" title with a "See all" link and a card
/// for the next reminder of the active pet.
class UpcomingReminderSection extends StatelessWidget {
  /// The next reminder, or null if the pet has none.
  final Reminder? reminder;
  final VoidCallback onOpenReminders;

  const UpcomingReminderSection({
    super.key,
    required this.reminder,
    required this.onOpenReminders,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Upcoming Reminders',
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            TextButton(
              onPressed: onOpenReminders,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        // Show the card if there is a reminder, otherwise a short message.
        reminder == null
            ? Text('No upcoming reminders', style: textTheme.bodyMedium)
            : _ReminderTile(reminder: reminder!, onTap: onOpenReminders),
      ],
    );
  }
}

/// Peach card with the reminder's icon, title, date and time.
class _ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback onTap;

  const _ReminderTile({required this.reminder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.reminderCardBackground,
          border: Border.all(color: AppColors.creamBorder),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            // Cream circle with the category icon.
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
              ),
              child: Icon(
                _iconFor(reminder.category),
                color: AppColors.reminderIcon,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs), // 12
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.secondaryText,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _whenText(reminder),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
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
    );
  }

  /// "10/11/2026 · 10:00" for one-time reminders, "Daily · 19:00" for daily.
  static String _whenText(Reminder reminder) {
    final time = formatTime(reminder.hour, reminder.minute);
    if (reminder.repeat == RepeatType.daily || reminder.date == null) {
      return 'Daily · $time';
    }
    return '${formatDate(reminder.date!)} · $time';
  }

  /// A different icon for each reminder category.
  static IconData _iconFor(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medication:
        return Icons.medication_outlined;
      case ReminderCategory.appointment:
        return Icons.notifications_none;
      case ReminderCategory.feeding:
        return Icons.restaurant_outlined;
      case ReminderCategory.other:
        return Icons.notifications_none;
    }
  }
}