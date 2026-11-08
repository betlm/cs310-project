/// One weight measurement it is used in the weight chart
class WeightEntry {
  final String id;
  final String petId;
  final double weightKg;
  final DateTime date;

  const WeightEntry({
    required this.id,
    required this.petId,
    required this.weightKg,
    required this.date,
  });
}