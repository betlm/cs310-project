/// Category options from the Create / edit reminder dropdown
enum ReminderCategory { medication, appointment, feeding, other }

/// A reminder either happens once or repeats every day
enum RepeatType { oneTime, daily }

/// A named reminder for one pet.
class Reminder {
  final String id;
  final String petId;
  final String title;
  final ReminderCategory category;
  final RepeatType repeat;
  final DateTime? date; // only used for one time reminders
  final int hour;
  final int minute;
  final bool sendNotification;
  final String? note;
  final bool isCompleted; // completed reminders 

  const Reminder({
    required this.id,
    required this.petId,
    required this.title,
    required this.category,
    required this.repeat,
    this.date,
    required this.hour,
    required this.minute,
    this.sendNotification = true,
    this.note,
    this.isCompleted = false,
  });
}