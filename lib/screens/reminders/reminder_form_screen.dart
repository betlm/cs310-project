
import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/reminder.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/form_field_decoration.dart' as shared_form;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (formInitialized) return;
    formInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Reminder) {
      editingReminder = arguments;

      nameController.text = arguments.title;
      noteController.text = arguments.note ?? '';
      selectedCategory = arguments.category;
      isDaily = arguments.repeat == RepeatType.daily;
      selectedDate = arguments.date;
      selectedTime = TimeOfDay(
        hour: arguments.hour,
        minute: arguments.minute,
      );
      sendNotification = arguments.sendNotification;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String categoryLabel(ReminderCategory category) {
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
        return AppColors.primary;
      case ReminderCategory.appointment:
        return AppColors.peach;
      case ReminderCategory.feeding:
        return const Color(0xFFE8D16F);
      case ReminderCategory.other:
        return const Color(0xFFCBB9D8);
    }
  }

  TextStyle get labelStyle => AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.darkGreen,
      );

  InputDecoration fieldDecoration({
  String? hint,
  Widget? prefixIcon,
}) {
  return shared_form.fieldDecoration(
    hint: hint,
    prefixIcon: prefixIcon,
  );
}
    

  Widget sectionLabel(String title, {bool required = false}) {
    return Row(
      children: [
        Text(title, style: labelStyle),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.danger,
            ),
          ),
      ],
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
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    const BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: selected
                  ? AppColors.darkGreen
                  : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }

  void saveReminder() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reminder name'),
        ),
      );
      return;
    }

    if (!isDaily && selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
        ),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time'),
        ),
      );
      return;
    }

    final note = noteController.text.trim();

    final reminder = Reminder(
      id: editingReminder?.id ??
          'rem-${DateTime.now().microsecondsSinceEpoch}',
      petId: editingReminder?.petId ?? activePet.id,
      title: nameController.text.trim(),
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
      // Create a new reminder.
      sampleReminders.add(reminder);
    } else {
      // Update the existing reminder.
      final index = sampleReminders.indexWhere(
        (item) => item.id == editingReminder!.id,
      );

      if (index == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminder could not be found'),
          ),
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
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Create / edit reminder',
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Save button stays visible at the bottom.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: saveReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.darkGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Save reminder',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reminder name
            sectionLabel('Reminder name', required: true),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              style: AppTextStyles.bodyLarge,
              decoration: fieldDecoration(
                hint: 'e.g. Evening meal',
              ),
            ),

            // Category
            const SizedBox(height: 24),
            sectionLabel('Category', required: true),
            const SizedBox(height: 12),
            DropdownButtonFormField<ReminderCategory>(
              key: ValueKey(selectedCategory),
              initialValue: selectedCategory,
              isExpanded: true,
              dropdownColor: AppColors.white,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: fieldDecoration().copyWith(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.6,
                  ),
                ),
              ),
              items: ReminderCategory.values.map((category) {
                return DropdownMenuItem<ReminderCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: categoryColor(category),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(categoryLabel(category)),
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
            sectionLabel('Repeat'),
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
                    title: 'One-time',
                    selected: !isDaily,
                    onTap: () {
                      setState(() {
                        isDaily = false;
                      });
                    },
                  ),
                  repeatOption(
                    title: 'Daily',
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

            // Date - only for one-time reminders.
            if (!isDaily) ...[
              const SizedBox(height: 24),
              sectionLabel('Date', required: true),
              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                style: AppTextStyles.bodyLarge,
                decoration: fieldDecoration(
                  hint: selectedDate == null
                      ? 'Select date'
                      : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}',
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.secondaryText,
                  ),
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
            sectionLabel('Time', required: true),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              style: AppTextStyles.bodyLarge,
              decoration: fieldDecoration(
                hint: selectedTime == null
                    ? 'Select time'
                    : selectedTime!.format(context),
                prefixIcon: const Icon(
                  Icons.access_time_outlined,
                  color: AppColors.secondaryText,
                ),
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
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'One-time reminders require Date and Time. '
                      'Daily reminders use Time only and repeat every day.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Send notification
            const SizedBox(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Send notification',
                style: labelStyle,
              ),
              subtitle: const Text(
                'Get notified when it is time for this reminder',
                style: AppTextStyles.bodyMedium,
              ),
              value: sendNotification,
              activeTrackColor: AppColors.primary,
              activeThumbColor: AppColors.darkGreen,
              onChanged: (value) {
                setState(() {
                  sendNotification = value;
                });
              },
            ),

            // Note
            const SizedBox(height: 24),
            sectionLabel('Note (optional)'),
            const SizedBox(height: 12),
            TextFormField(
              controller: noteController,
              maxLines: 4,
              style: AppTextStyles.bodyLarge,
              decoration: fieldDecoration(
                hint: 'Add a note...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
