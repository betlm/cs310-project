import '../models/pet.dart';
import '../models/reminder.dart';
import '../models/health_record.dart';
import '../models/weight_entry.dart';
import '../models/supply_item.dart';
import '../models/pet_photo.dart';
import 'sample_data.dart';

/// The pet currently selected in the app.
///
/// Screens read this value when they build. To change it, a screen assigns a new pet inside setState, so the screen rebuilds with it.
Pet activePet = samplePets.first;

// Helpers that return only the records of one pet.

List<Reminder> remindersFor(String petId) {
  return sampleReminders.where((r) => r.petId == petId).toList();
}

List<HealthRecord> healthRecordsFor(String petId) {
  final records =
      sampleHealthRecords.where((r) => r.petId == petId).toList();
  records.sort((a, b) => b.date.compareTo(a.date)); // newest first
  return records;
}

List<WeightEntry> weightEntriesFor(String petId) {
  final entries =
      sampleWeightEntries.where((w) => w.petId == petId).toList();
  entries.sort((a, b) => a.date.compareTo(b.date)); // oldest first
  return entries;
}

List<SupplyItem> suppliesFor(String petId) {
  return sampleSupplies.where((s) => s.petId == petId).toList();
}

List<PetPhoto> photosFor(String petId) {
  return samplePhotos.where((p) => p.petId == petId).toList();
}

/// Number of supply items not yet bought, shown on Home as "3 pending".
int pendingSupplyCount(String petId) {
  return suppliesFor(petId).where((s) => !s.bought).length;
}

/// The next time a reminder is due.
///
/// One-time reminders use their own date. Daily reminders use today attheir time, or tomorrow if that time has already passed.
DateTime nextOccurrence(Reminder reminder) {
  if (reminder.repeat == RepeatType.oneTime && reminder.date != null) {
    final d = reminder.date!;
    return DateTime(d.year, d.month, d.day, reminder.hour, reminder.minute);
  }

  final now = DateTime.now();
  var next =
      DateTime(now.year, now.month, now.day, reminder.hour, reminder.minute);
  if (next.isBefore(now)) {
    next = next.add(const Duration(days: 1));
  }
  return next;
}

/// A reminder is upcoming if it is not completed and, for one-time
/// reminders, its date and time have not passed yet.
/// The same rule is used on Home and on the Reminders screen.
bool isUpcoming(Reminder reminder) {
  if (reminder.isCompleted) return false;
  if (reminder.repeat == RepeatType.daily) return true;
  return !nextOccurrence(reminder).isBefore(DateTime.now());
}

/// The upcoming reminder of a pet that is due first or null if the pet has no upcoming reminders.
Reminder? nextReminderFor(String petId) {
  final upcoming = remindersFor(petId).where(isUpcoming).toList();
  if (upcoming.isEmpty) return null;

  upcoming.sort((a, b) => nextOccurrence(a).compareTo(nextOccurrence(b)));
  return upcoming.first;
}