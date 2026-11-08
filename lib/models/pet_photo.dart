/// A photo in a pet's album
class PetPhoto {
  final String id;
  final String petId;
  final String imageUrl; // network image for now, Supabase URL in Step 3
  final DateTime addedAt;

  const PetPhoto({
    required this.id,
    required this.petId,
    required this.imageUrl,
    required this.addedAt,
  });
}