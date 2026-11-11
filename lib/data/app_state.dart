import 'package:flutter/foundation.dart';

import '../models/pet.dart';
import '../models/reminder.dart';
import '../models/health_record.dart';
import '../models/weight_entry.dart';
import '../models/supply_item.dart';
import '../models/pet_photo.dart';
import 'sample_data.dart';

/// The pet currently selected in the app
///
/// Every screen shows data for this pet. When it changes (for example from
/// the pet switcher or the pet chips on Home), screens that listen to it
/// rebuild automatically.
final ValueNotifier<Pet> activePet = ValueNotifier<Pet>(samplePets.first);

/// Notifies listeners whenever any sample list changes
/// (a record, reminder, supply or photo is added, edited or removed).
///
/// Screens that show counts or lists listen to this together with
/// [activePet] so they always show the latest data.
final ValueNotifier<int> dataChanged = ValueNotifier<int>(0);

/// Call this after changing any of the sample data lists.
void notifyDataChanged() {
  dataChanged.value++;
}
/// Makes pet the active pet.
void selectPet(Pet pet) {
  activePet.value = pet;
}

// Helpers that return only the active pet's records.

List<Reminder> remindersFor(String petId) =>
    sampleReminders.where((r) => r.petId == petId).toList();

List<HealthRecord> healthRecordsFor(String petId) =>
    sampleHealthRecords.where((r) => r.petId == petId).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first

List<WeightEntry> weightEntriesFor(String petId) =>
    sampleWeightEntries.where((w) => w.petId == petId).toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // oldest first, for the chart

List<SupplyItem> suppliesFor(String petId) =>
    sampleSupplies.where((s) => s.petId == petId).toList();

List<PetPhoto> photosFor(String petId) =>
    samplePhotos.where((p) => p.petId == petId).toList();

/// Number of supply items not yet bought, shown on Home as "3 pending".
int pendingSupplyCount(String petId) =>
    suppliesFor(petId).where((s) => !s.bought).length;


/// The next time reminder is due.
///
/// One-time reminders use their own date. Daily reminders use today at
/// their time, or tomorrow if that time has already passed.
DateTime nextOccurrence(Reminder reminder) {
  if (reminder.repeat == RepeatType.oneTime && reminder.date != null) {
    final d = reminder.date!;
    return DateTime(d.year, d.month, d.day, reminder.hour, reminder.minute);
  }

  final now = DateTime.now();
  var next = DateTime(
      now.year, now.month, now.day, reminder.hour, reminder.minute);
  if (next.isBefore(now)) {
    next = next.add(const Duration(days: 1));
  }
  return next;
}

/// The not-yet-completed reminder of petId that is due first,
/// or null if the pet has no active reminders.
Reminder? nextReminderFor(String petId) {
  final active = remindersFor(petId).where((r) => !r.isCompleted).toList()
    ..sort((a, b) => nextOccurrence(a).compareTo(nextOccurrence(b)));
  return active.isEmpty ? null : active.first;
}