import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/reminder.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/primary_button.dart';
import '../../l10n/app_strings.dart';
import '../../utils/sample_localization.dart';
import '../../utils/date_format.dart';
import '../../theme/reminder_category_colors.dart';

class ReminderFormScreen extends StatefulWidget {
  const ReminderFormScreen({super.key});

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController noteController = TextEditingController();

  ReminderCategory selectedCategory = ReminderCategory.appointment;

  bool isDaily = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool sendNotification = true;

  Reminder? editingReminder;
  bool formInitialized = false;

  TextStyle get formTextStyle =>
      AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGreen);

  TextStyle get formHintStyle =>
      AppTextStyles.bodyMedium.copyWith(color: AppColors.hint);

  InputDecoration formDecoration({String? hint, IconData? icon}) {
    return fieldDecoration(
      hint: hint,
      icon: icon,
    ).copyWith(hintStyle: formHintStyle);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (formInitialized) return;
    formInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Reminder) {
      editingReminder = arguments;

      nameController.text = SampleLocalization.text(
        id: arguments.id,
        field: 'title',
        value: arguments.title,
      );
      noteController.text = arguments.note ?? '';
      selectedCategory = arguments.category;
      isDaily = arguments.repeat == RepeatType.daily;
      selectedDate = arguments.date;

      selectedTime = TimeOfDay(hour: arguments.hour, minute: arguments.minute);

      sendNotification = arguments.sendNotification;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Widget sectionLabel(String title, {bool required = false}) {
    final labelStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.darkGreen,
      fontWeight: FontWeight.w700,
    );

    if (!required) {
      return Text(title, style: labelStyle);
    }

    return Text.rich(
      TextSpan(
        style: labelStyle,
        children: [
          TextSpan(text: title),
          TextSpan(
            text: ' *',
            style: labelStyle.copyWith(color: AppColors.danger),
          ),
        ],
      ),
    );
  }

  Widget repeatOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
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
            style: AppTextStyles.bodyMedium.copyWith(
              color: selected ? AppColors.darkGreen : AppColors.secondaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void saveReminder() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('enterReminderName'))),
      );
      return;
    }

    if (!isDaily && selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('selectDateError'))),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('selectTimeError'))),
      );
      return;
    }

    final note = noteController.text.trim();

    final enteredTitle = nameController.text.trim();

    final originalDisplayedTitle = editingReminder == null
        ? null
        : SampleLocalization.text(
            id: editingReminder!.id,
            field: 'title',
            value: editingReminder!.title,
          );

    final titleToSave =
        editingReminder != null && enteredTitle == originalDisplayedTitle
        ? editingReminder!.title
        : enteredTitle;

    final reminder = Reminder(
      id: editingReminder?.id ?? 'rem-${DateTime.now().microsecondsSinceEpoch}',
      petId: editingReminder?.petId ?? activePet.id,
      title: titleToSave,
      category: selectedCategory,
      repeat: isDaily ? RepeatType.daily : RepeatType.oneTime,
      date: isDaily ? null : selectedDate,
      hour: selectedTime!.hour,
      minute: selectedTime!.minute,
      sendNotification: sendNotification,
      note: note.isEmpty ? null : note,
      isCompleted: editingReminder?.isCompleted ?? false,
    );

    if (editingReminder == null) {
      sampleReminders.add(reminder);
    } else {
      final index = sampleReminders.indexWhere(
        (item) => item.id == editingReminder!.id,
      );

      if (index == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('reminderNotFound'))),
        );
        return;
      }

      sampleReminders[index] = reminder;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
          editingReminder == null
              ? AppStrings.get('addReminderTitle')
              : AppStrings.get('editReminderTitle'),
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.cardBorder)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: PrimaryButton(
            text: editingReminder == null
                ? AppStrings.get('saveReminder')
                : AppStrings.get('saveChanges'),
            onPressed: saveReminder,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reminder name
            sectionLabel(AppStrings.get('reminderName'), required: true),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              style: formTextStyle,
              decoration: formDecoration(
                hint: AppStrings.get('reminderNameHint'),
              ),
            ),

            // Category
            const SizedBox(height: 24),
            sectionLabel(AppStrings.get('category'), required: true),
            const SizedBox(height: 12),
            DropdownButtonFormField<ReminderCategory>(
              key: ValueKey(selectedCategory),
              initialValue: selectedCategory,
              isExpanded: true,
              dropdownColor: AppColors.white,
              style: formTextStyle.copyWith(fontWeight: FontWeight.w600),
              decoration: formDecoration(),
              items: ReminderCategory.values.map((category) {
                return DropdownMenuItem<ReminderCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: reminderCategoryColor(category),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(AppStrings.get(category.name))
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            // Repeat
            const SizedBox(height: 24),
            sectionLabel(AppStrings.get('repeat')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  repeatOption(
                    title: AppStrings.get('oneTime'),
                    selected: !isDaily,
                    onTap: () {
                      setState(() {
                        isDaily = false;
                      });
                    },
                  ),
                  repeatOption(
                    title: AppStrings.get('daily'),
                    selected: isDaily,
                    onTap: () {
                      setState(() {
                        isDaily = true;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Date
            if (!isDaily) ...[
              const SizedBox(height: 24),
              sectionLabel(AppStrings.get('date'), required: true),
              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                style: formTextStyle,
                decoration: formDecoration(
                  hint: selectedDate == null
                      ? AppStrings.get('selectDate')
                      : formatDate(selectedDate!),
                  icon: Icons.calendar_today_outlined,
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null && mounted) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],

            // Time
            const SizedBox(height: 24),
            sectionLabel(AppStrings.get('time'), required: true),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              style: formTextStyle,
              decoration: formDecoration(
                hint: selectedTime == null
                    ? AppStrings.get('selectTime')
                    : formatTime(selectedTime!.hour, selectedTime!.minute),
                icon: Icons.access_time_outlined,
              ),
              onTap: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );

                if (pickedTime != null && mounted) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
            ),

            // Information box
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.get('reminderInfo'),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Send notification
            const SizedBox(height: 24),
            Divider(color: AppColors.cardBorder),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: sectionLabel(AppStrings.get('sendNotification')),
              subtitle: Text(
                AppStrings.get('sendNotificationSubtitle'),
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: sendNotification,
              activeTrackColor: AppColors.primary,
              activeThumbColor: AppColors.white,
              onChanged: (value) {
                setState(() {
                  sendNotification = value;
                });
              },
            ),

            // Note
            Divider(color: AppColors.cardBorder),
            const SizedBox(height: 20),
            sectionLabel(AppStrings.get('noteOptional')),
            const SizedBox(height: 12),
            TextFormField(
              controller: noteController,
              maxLines: 4,
              style: formTextStyle,
              decoration: formDecoration(hint: AppStrings.get('addShortNote')),
            ),
          ],
        ),
      ),
    );
  }
}
