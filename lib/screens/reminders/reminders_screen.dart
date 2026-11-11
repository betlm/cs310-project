import 'package:flutter/material.dart';

import '../../data/app_state.dart' as app_state;
import '../../data/sample_data.dart';
import '../../models/pet.dart';
import '../../models/reminder.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/active_profile_card.dart';
import '../home/widgets/pet_chips_row.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool showUpcoming = true;

  String speciesName(PetSpecies species) {
    switch (species) {
      case PetSpecies.cat:
        return 'Cat';
      case PetSpecies.dog:
        return 'Dog';
      case PetSpecies.bird:
        return 'Bird';
      case PetSpecies.fish:
        return 'Fish';
      case PetSpecies.rabbit:
        return 'Rabbit';
      case PetSpecies.hamster:
        return 'Hamster';
    }
  }

  Future<void> selectActivePet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a pet',
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 20),
                PetChipsRow(
                  selectedPet: app_state.activePet,
                  onPetSelected: (Pet pet) {
                    setState(() {
                      app_state.activePet = pet;
                    });
                    Navigator.pop(sheetContext);
                  },
                  onAddPet: () {
                    Navigator.pop(sheetContext);
                    openScreen(AppRoutes.petForm);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> openScreen(String routeName) async {
    await Navigator.pushNamed(context, routeName);

    if (!mounted) return;

    setState(() {});
  }

  IconData categoryIcon(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medication:
        return Icons.notifications_none;
      case ReminderCategory.appointment:
        return Icons.calendar_month_outlined;
      case ReminderCategory.feeding:
        return Icons.access_time;
      case ReminderCategory.other:
        return Icons.notifications_outlined;
    }
  }

  String categoryName(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medication:
        return 'Medication';
      case ReminderCategory.appointment:
        return 'Appointment';
      case ReminderCategory.feeding:
        return 'Feeding';
      case ReminderCategory.other:
        return 'Other';
    }
  }

  Color categoryColor(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medication:
        return AppColors.darkGreen;
      case ReminderCategory.appointment:
        return AppColors.peach;
      case ReminderCategory.feeding:
        return const Color(0xFFEAD56F);
      case ReminderCategory.other:
        return const Color(0xFFD3C1E2);
    }
  }

  String formatTime(Reminder reminder) {
    final hour = reminder.hour.toString().padLeft(2, '0');
    final minute = reminder.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> confirmDeleteReminder(Reminder reminder) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.background,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(
              color: AppColors.mintBorder,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF0E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFB45F57),
                    size: 34,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Delete ${reminder.title}?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This reminder will be permanently removed. '
                  'This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkGreen,
                          backgroundColor: AppColors.white,
                          minimumSize: const Size(0, 52),
                          side: const BorderSide(
                            color: AppColors.mintBorder,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB45F57),
                          foregroundColor: AppColors.white,
                          minimumSize: const Size(0, 52),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete == true && mounted) {
      setState(() {
        sampleReminders.removeWhere(
          (item) => item.id == reminder.id,
        );
      });
    }
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 12,
      ),
      child: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryText,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget buildReminderCard(Reminder reminder) {
    final badgeColor = categoryColor(reminder.category);

    final darkBadge =
        reminder.category == ReminderCategory.medication;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMedium,
        ),
        side: const BorderSide(
          color: AppColors.mintBorder,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusMedium,
                ),
              ),
              child: Icon(
                reminder.isCompleted
                    ? Icons.check_circle_outline
                    : categoryIcon(reminder.category),
                color: AppColors.darkGreen,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    reminder.repeat == RepeatType.daily
                        ? 'Daily · ${formatTime(reminder)}'
                        : '${formatTime(reminder)} · One-time',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusSmall,
                      ),
                    ),
                    child: Text(
                      categoryName(reminder.category),
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: darkBadge
                            ? AppColors.white
                            : AppColors.darkGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Edit reminder
            IconButton(
              constraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 40,
              ),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.darkGreen,
              tooltip: 'Edit reminder',
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  AppRoutes.reminderForm,
                  arguments: reminder,
                );

                if (!mounted) return;

                setState(() {});
              },
            ),

            // Delete reminder
            IconButton(
              iconSize: 20,
              constraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 40,
              ),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete_outline),
              color: const Color(0xFFB85B52),
              tooltip: 'Delete reminder',
              onPressed: () {
                confirmDeleteReminder(reminder);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReminderList(List<Reminder> reminders) {
    if (reminders.isEmpty) {
      return Center(
        child: Text(
          'No reminders found',
          style: AppTextStyles.bodyMedium,
        ),
      );
    }

    final sorted = List<Reminder>.from(reminders);

    sorted.sort((a, b) {
      if (a.repeat == RepeatType.daily &&
          b.repeat != RepeatType.daily) {
        return 1;
      }

      if (a.repeat != RepeatType.daily &&
          b.repeat == RepeatType.daily) {
        return -1;
      }

      if (a.repeat == RepeatType.daily &&
          b.repeat == RepeatType.daily) {
        final aMinutes = a.hour * 60 + a.minute;
        final bMinutes = b.hour * 60 + b.minute;
        return aMinutes.compareTo(bMinutes);
      }

      final aDate = a.date ?? DateTime(2100);
      final bDate = b.date ?? DateTime(2100);
      final dateOrder = aDate.compareTo(bDate);

      if (dateOrder != 0) return dateOrder;

      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final reminder = sorted[index];
        final previous = index > 0 ? sorted[index - 1] : null;
        final daily = reminder.repeat == RepeatType.daily;

        bool showHeader = index == 0;

        if (previous != null) {
          if (daily) {
            showHeader = previous.repeat != RepeatType.daily;
          } else {
            showHeader =
                previous.repeat == RepeatType.daily ||
                previous.date != reminder.date;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              buildSectionTitle(
                daily
                    ? 'EVERY DAY'
                    : reminder.date == null
                        ? 'NO DATE'
                        : formatDate(reminder.date!),
              ),
            buildReminderCard(reminder),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = app_state.activePet;

    final reminders = app_state
        .remindersFor(pet.id)
        .where(
          (reminder) =>
              app_state.isUpcoming(reminder) == showUpcoming,
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkGreen,
        centerTitle: true,
        title: Text(
          'Reminders',
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Active profile
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ActiveProfileCard(
              petName: pet.name,
              petType: speciesName(pet.species),
              imageUrl: pet.avatarPath,
              onTap: selectActivePet,
            ),
          ),

          // Add reminder card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              color: AppColors.lightMint,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusLarge,
                ),
                side: const BorderSide(
                  color: AppColors.mintBorder,
                  width: 1.5,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.darkGreen,
                    size: 30,
                  ),
                ),
                title: Text(
                  'Add reminder',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Schedule care, medication, or visits',
                  style: AppTextStyles.bodyMedium,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.darkGreen,
                ),
                onTap: () => openScreen(AppRoutes.reminderForm),
              ),
            ),
          ),

          // Upcoming / Past tabs
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showUpcoming = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: showUpcoming
                              ? AppColors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Upcoming',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: showUpcoming
                                ? AppColors.darkGreen
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showUpcoming = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: !showUpcoming
                              ? AppColors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Past',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: !showUpcoming
                                ? AppColors.darkGreen
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Reminder list
          Expanded(
            child: buildReminderList(reminders),
          ),
        ],
      ),
    );
  }
}