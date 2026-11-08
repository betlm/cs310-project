/// Record types from the Create / edit record dropdown
/// The Health history filter chips use the same list
enum HealthRecordType {
  vaccination,
  vetVisit,
  checkUp,
  medication,
  parasiteTreatment,
  feedingNote,
  other,
}

/// A dated health record for one pet 
class HealthRecord {
  final String id;
  final String petId;
  final HealthRecordType type;
  final String title;
  final DateTime date;
  final String? notes;
  final String? attachmentUrl; // optional JPG/PNG photo

  const HealthRecord({
    required this.id,
    required this.petId,
    required this.type,
    required this.title,
    required this.date,
    this.notes,
    this.attachmentUrl,
  });
}