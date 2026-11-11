
import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../models/reminder.dart';
import '../../routes/app_routes.dart';
import '../../widgets/active_profile_card.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool showUpcoming = true;

  final Set<String> deletedReminderIds = {};

  bool isUpcoming(Reminder reminder) {
    if (reminder.isCompleted) return false;

    if (reminder.repeat == RepeatType.daily) {
      return true;
    }

    if (reminder.date == null) return false;

    final reminderDateTime = DateTime(
      reminder.date!.year,
      reminder.date!.month,
      reminder.date!.day,
      reminder.hour,
      reminder.minute,
    );

    return !reminderDateTime.isBefore(DateTime.now());
  }

  IconData getCategoryIcon(ReminderCategory category) {
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

  String getCategoryName(ReminderCategory category) {
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

  Color getCategoryColor(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medication:
        return const Color(0xFF263F39);
      case ReminderCategory.appointment:
        return const Color(0xFFF3AE94);
      case ReminderCategory.feeding:
        return const Color(0xFFEAD56F);
      case ReminderCategory.other:
        return const Color(0xFFB8E3D9);
    }
  }

  String formatTime(Reminder reminder) {
    final hour = reminder.hour.toString().padLeft(2, '0');
    final minute = reminder.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String formatDate(Reminder reminder) {
    final date = reminder.date;
    if (date == null) return 'No date';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String getPetName(Reminder reminder) {
    final matchingPets = samplePets.where(
      (pet) => pet.id == reminder.petId,
    );

    return matchingPets.isNotEmpty
        ? matchingPets.first.name
        : 'Unknown pet';
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF788783),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget buildReminderCard(Reminder reminder) {
    final categoryColor = getCategoryColor(reminder.category);
    final isDark = reminder.category == ReminderCategory.medication;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFD9E1DE),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F5F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                reminder.isCompleted
                    ? Icons.check_circle_outline
                    : getCategoryIcon(reminder.category),
                color: const Color(0xFF263F39),
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
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263F39),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    reminder.repeat == RepeatType.daily
                        ? 'Daily · ${formatTime(reminder)}'
                        : '${formatTime(reminder)} · One-time',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF667773),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      getCategoryName(reminder.category),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF263F39),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              constraints: const BoxConstraints(
               minWidth: 30,
               minHeight: 40,
              ),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit_outlined),
    
              color: const Color(0xFF263F39),
              tooltip: 'Edit reminder',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.reminderForm,
                );
              },
            ),
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
                setState(() {
                  deletedReminderIds.add(reminder.id);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReminderList(List<Reminder> reminders) {
    if (reminders.isEmpty) {
      return const Center(
        child: Text('No reminders found'),
      );
    }

    final sortedReminders = List<Reminder>.from(reminders);

    sortedReminders.sort((a, b) {
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
        return a.hour.compareTo(b.hour);
      }

      final dateA = a.date ?? DateTime(2100);
      final dateB = b.date ?? DateTime(2100);

      return dateA.compareTo(dateB);
    });

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: sortedReminders.length,
      itemBuilder: (context, index) {
        final reminder = sortedReminders[index];
        final previous = index > 0
            ? sortedReminders[index - 1]
            : null;

        final isDaily = reminder.repeat == RepeatType.daily;

        bool showHeader = index == 0;

        if (previous != null) {
          if (isDaily) {
            showHeader = previous.repeat != RepeatType.daily;
          } else {
            showHeader =
                previous.repeat == RepeatType.daily ||
                formatDate(previous) != formatDate(reminder);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              buildSectionTitle(
                isDaily
                    ? 'EVERY DAY'
                    : formatDate(reminder),
              ),
            buildReminderCard(reminder),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = sampleReminders.where((reminder) {
      return reminder.petId == 'pet-1' &&
          !deletedReminderIds.contains(reminder.id) &&
          isUpcoming(reminder) == showUpcoming;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add reminder',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.reminderForm,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ActiveProfileCard(
              petName: 'Misket',
              petType: 'Cat',
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              color: const Color(0xFFFFFCF8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: Color(0xFFB8E3D9),
                  width: 1.5,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF64BFB0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF263F39),
                    size: 30,
                  ),
                ),
                title: const Text(
                  'Add reminder',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263F39),
                  ),
                ),
                subtitle: const Text(
                  'Schedule care, medication, or visits',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.reminderForm,
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F5F0),
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
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Upcoming',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: showUpcoming
                                ? const Color(0xFF263F39)
                                : Colors.grey,
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
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Past',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !showUpcoming
                                ? const Color(0xFF263F39)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: buildReminderList(reminders),
          ),
        ],
      ),
    );
  }
}
