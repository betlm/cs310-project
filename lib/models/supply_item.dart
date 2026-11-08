/// An item in a pet's shopping list
class SupplyItem {
  final String id;
  final String petId;
  final String name;
  final int quantity;
  final String? unit; // 'kg', 'pack'
  final String? note;
  final bool bought;

  const SupplyItem({
    required this.id,
    required this.petId,
    required this.name,
    required this.quantity,
    this.unit,
    this.note,
    this.bought = false,
  });

  SupplyItem copyWith({
    String? name,
    int? quantity,
    String? unit,
    String? note,
    bool? bought,
  }) {
    return SupplyItem(
      id: id,
      petId: petId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      bought: bought ?? this.bought,
    );
  }
}