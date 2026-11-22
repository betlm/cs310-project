import 'package:flutter/material.dart';

import '../models/reminder.dart';
import 'app_colors.dart';

Color reminderCategoryColor(
  ReminderCategory category, {
  bool forBadge = false,
}) {
  return switch (category) {
    ReminderCategory.medication =>
      forBadge ? AppColors.darkGreen : AppColors.primary,
    ReminderCategory.appointment => AppColors.peach,
    ReminderCategory.feeding => AppColors.speciesBird,
    ReminderCategory.other => AppColors.speciesHamster,
  };
}