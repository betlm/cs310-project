import '../models/pet.dart';
import '../models/reminder.dart';
import '../models/health_record.dart';
import '../models/weight_entry.dart';
import '../models/supply_item.dart';
import '../models/pet_photo.dart';

// Placeholder data used until Firebase is added in Step 3.
// All screens read from these lists so that they show the same information.
// The lists are not const, so items can be added or removed while the app runs.

// ---------------------------------------------------------------------------
// Pets
// ---------------------------------------------------------------------------

final List<Pet> samplePets = [
  Pet(
    id: 'pet-1',
    name: 'Misket',
    species: PetSpecies.cat,
    breed: 'Tabby',
    birthDate: DateTime(2023, 4, 12),
    sex: PetSex.female,
    weightKg: 4.8,
    microchipNumber: '900215000123456',
    tagInfo: 'PP-0441',
  ),
  Pet(
    id: 'pet-2',
    name: 'Ponçik',
    species: PetSpecies.dog,
    breed: 'Golden retriever',
    approximateAgeYears: 5,
    sex: PetSex.male,
    weightKg: 29.5,
  ),
  Pet(
    id: 'pet-3',
    name: 'Cleo',
    species: PetSpecies.bird,
    breed: 'Budgerigar',
    approximateAgeYears: 2,
  ),
];

// ---------------------------------------------------------------------------
// Reminders
// ---------------------------------------------------------------------------

final List<Reminder> sampleReminders = [
  // Misket: upcoming
  Reminder(
    id: 'rem-1',
    petId: 'pet-1',
    title: 'Combination vaccine',
    category: ReminderCategory.appointment,
    repeat: RepeatType.oneTime,
    date: DateTime(2026, 11, 10),
    hour: 10,
    minute: 0,
  ),
  Reminder(
    id: 'rem-2',
    petId: 'pet-1',
    title: 'Internal parasite medicine',
    category: ReminderCategory.medication,
    repeat: RepeatType.oneTime,
    date: DateTime(2026, 11, 14),
    hour: 9,
    minute: 0,
  ),
  Reminder(
    id: 'rem-3',
    petId: 'pet-1',
    title: 'Evening meal',
    category: ReminderCategory.feeding,
    repeat: RepeatType.daily,
    hour: 19,
    minute: 0,
  ),
  // Misket: past
  Reminder(
    id: 'rem-4',
    petId: 'pet-1',
    title: 'Morning medication',
    category: ReminderCategory.medication,
    repeat: RepeatType.oneTime,
    date: DateTime(2026, 11, 8),
    hour: 9,
    minute: 0,
    isCompleted: true,
  ),
  Reminder(
    id: 'rem-5',
    petId: 'pet-1',
    title: 'Vet check-up',
    category: ReminderCategory.appointment,
    repeat: RepeatType.oneTime,
    date: DateTime(2026, 11, 2),
    hour: 14,
    minute: 30,
    isCompleted: true,
  ),
  // Other pets
  Reminder(
    id: 'rem-6',
    petId: 'pet-2',
    title: 'Morning walk',
    category: ReminderCategory.other,
    repeat: RepeatType.daily,
    hour: 8,
    minute: 0,
  ),
  Reminder(
    id: 'rem-7',
    petId: 'pet-3',
    title: 'Refill seeds',
    category: ReminderCategory.feeding,
    repeat: RepeatType.daily,
    hour: 18,
    minute: 0,
  ),
];

// ---------------------------------------------------------------------------
// Health records
// ---------------------------------------------------------------------------

final List<HealthRecord> sampleHealthRecords = [
  HealthRecord(
    id: 'hr-1',
    petId: 'pet-1',
    type: HealthRecordType.checkUp,
    title: 'Routine check-up',
    date: DateTime(2026, 10, 22),
    notes: 'General examination completed. Everything is normal.',
  ),
  HealthRecord(
    id: 'hr-2',
    petId: 'pet-1',
    type: HealthRecordType.vaccination,
    title: 'Combination vaccine',
    date: DateTime(2026, 10, 18),
    notes: 'Annual booster dose administered.',
  ),
  HealthRecord(
    id: 'hr-3',
    petId: 'pet-1',
    type: HealthRecordType.medication,
    title: 'Eye drops',
    date: DateTime(2026, 10, 9),
    notes: 'Seven-day medication course completed.',
  ),
  HealthRecord(
    id: 'hr-4',
    petId: 'pet-1',
    type: HealthRecordType.parasiteTreatment,
    title: 'External parasite treatment',
    date: DateTime(2026, 10, 2),
    notes: 'Monthly drops administered.',
  ),
  HealthRecord(
    id: 'hr-5',
    petId: 'pet-2',
    type: HealthRecordType.vetVisit,
    title: 'Annual vet visit',
    date: DateTime(2026, 9, 15),
  ),
];

// ---------------------------------------------------------------------------
// Weight entries
// ---------------------------------------------------------------------------

final List<WeightEntry> sampleWeightEntries = [
  WeightEntry(id: 'w-1', petId: 'pet-1', weightKg: 4.5, date: DateTime(2026, 7, 12)),
  WeightEntry(id: 'w-2', petId: 'pet-1', weightKg: 4.6, date: DateTime(2026, 8, 12)),
  WeightEntry(id: 'w-3', petId: 'pet-1', weightKg: 4.7, date: DateTime(2026, 9, 12)),
  WeightEntry(id: 'w-4', petId: 'pet-1', weightKg: 4.8, date: DateTime(2026, 10, 12)),
  WeightEntry(id: 'w-5', petId: 'pet-2', weightKg: 29.5, date: DateTime(2026, 10, 1)),
];

// ---------------------------------------------------------------------------
// Supplies
// ---------------------------------------------------------------------------

final List<SupplyItem> sampleSupplies = [
  const SupplyItem(id: 's-1', petId: 'pet-1', name: 'Dry food', quantity: 2, unit: 'kg'),
  const SupplyItem(id: 's-2', petId: 'pet-1', name: 'Cat litter', quantity: 1, unit: 'pack'),
  const SupplyItem(id: 's-3', petId: 'pet-1', name: 'Toy mouse', quantity: 1),
  const SupplyItem(
      id: 's-4', petId: 'pet-1', name: 'Hairball paste', quantity: 1, bought: true),
  const SupplyItem(id: 's-5', petId: 'pet-2', name: 'Dog treats', quantity: 1, unit: 'pack'),
];

// ---------------------------------------------------------------------------
// Photos (network images)
// ---------------------------------------------------------------------------

final List<PetPhoto> samplePhotos = List.generate(
  8,
  (i) => PetPhoto(
    id: 'photo-${i + 1}',
    petId: 'pet-1',
    imageUrl: 'https://picsum.photos/seed/misket${i + 1}/400/400',
    addedAt: DateTime(2026, 10, 1 + i),
  ),
);