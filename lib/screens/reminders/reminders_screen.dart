import 'package:flutter/material.dart';

import '../../data/app_state.dart' as app_state;
import '../../data/sample_data.dart';
import '../../models/reminder.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/active_pet_bar.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/pet_switcher_sheet.dart';
import '../../widgets/square_icon_button.dart';
import '../../l10n/app_strings.dart';
import '../../utils/sample_localization.dart';
import '../../utils/date_format.dart';
import '../../theme/reminder_category_colors.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool showUpcoming = true;

  Future<void> selectActivePet() async {
    await showPetSwitcher(context);

    if (!mounted) return;
    setState(() {});
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

  Future<void> confirmDeleteReminder(Reminder reminder) async {
    final shouldDelete = await showConfirmDialog(
      context: context,
      title: AppStrings.get('deleteReminderTitle').replaceAll(
        '{name}',
        SampleLocalization.text(
          id: reminder.id,
          field: 'title',
          value: reminder.title,
        ),
      ),
      message: AppStrings.get('deleteReminderMessage'),
      confirmText: AppStrings.get('delete'),
    );

    if (!mounted) return;

    if (shouldDelete) {
      setState(() {
        sampleReminders.removeWhere((item) => item.id == reminder.id);
      });
    }
  }

  Widget buildReminderTab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: selected ? AppColors.darkGreen : AppColors.secondaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget buildReminderCard(Reminder reminder) {
    final badgeColor = reminderCategoryColor(
      reminder.category,
      forBadge: true,
    );
    final isDarkBadge = reminder.category == ReminderCategory.medication;
    final time = formatTime(reminder.hour, reminder.minute);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightMint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              reminder.isCompleted
                  ? Icons.check_circle_outline
                  : categoryIcon(reminder.category),
              color: AppColors.darkGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SampleLocalization.text(
                    id: reminder.id,
                    field: 'title',
                    value: reminder.title,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontFamily: 'Manrope',
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  reminder.repeat == RepeatType.daily
                    ? '${AppStrings.get('daily')} · $time'
                    : '$time · ${AppStrings.get('oneTime')}',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppStrings.get(reminder.category.name),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDarkBadge
                          ? AppColors.white
                          : AppColors.darkGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          SquareIconButton(
            icon: Icons.edit_outlined,
            color: AppColors.darkGreen,
            size: 34,
            onTap: () async {
              await Navigator.pushNamed(
                context,
                AppRoutes.reminderForm,
                arguments: reminder,
              );

              if (!mounted) return;
              setState(() {});
            },
          ),
          const SizedBox(width: 6),
          SquareIconButton(
            icon: Icons.delete_outline,
            color: AppColors.danger,
            size: 34,
            onTap: () => confirmDeleteReminder(reminder),
          ),
        ],
      ),
    );
  }

  Widget buildReminderList(List<Reminder> reminders) {
    if (reminders.isEmpty) {
      return Center(
        child: Text(
          AppStrings.get('noRemindersFound'),
          style: AppTextStyles.bodyMedium,
        ),
      );
    }

    final sorted = List<Reminder>.from(reminders);

    sorted.sort((a, b) {
      if (a.repeat == RepeatType.daily && b.repeat != RepeatType.daily) {
        return 1;
      }

      if (a.repeat != RepeatType.daily && b.repeat == RepeatType.daily) {
        return -1;
      }

      if (a.repeat == RepeatType.daily && b.repeat == RepeatType.daily) {
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final reminder = sorted[index];
        final previous = index > 0 ? sorted[index - 1] : null;
        final isDaily = reminder.repeat == RepeatType.daily;

        bool showHeader = index == 0;

        if (previous != null) {
          if (isDaily) {
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
                isDaily
                    ? AppStrings.get('everyDay').toUpperCase()
                    : reminder.date == null
                    ? AppStrings.get('noDate').toUpperCase()
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
        .where((reminder) => app_state.isUpcoming(reminder) == showUpcoming)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        title: Text(
          AppStrings.get('reminders'),
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: ActivePetBar(pet: pet, onTap: selectActivePet),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: InkWell(
              onTap: () => openScreen(AppRoutes.reminderForm),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightMint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.darkGreen,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.get('addReminder'),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkGreen,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppStrings.get('addReminderSubtitle'),
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.darkGreen),
                  ],
                ),
              ),
            ),
          ),
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
                  buildReminderTab(
                    title: AppStrings.get('upcoming'),
                    selected: showUpcoming,
                    onTap: () {
                      setState(() => showUpcoming = true);
                    },
                  ),
                  buildReminderTab(
                    title: AppStrings.get('past'),
                    selected: !showUpcoming,
                    onTap: () {
                      setState(() => showUpcoming = false);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: buildReminderList(reminders)),
        ],
      ),
    );
  }
}
