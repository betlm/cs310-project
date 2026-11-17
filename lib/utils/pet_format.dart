import '../models/pet.dart';
import '../theme/species_colors.dart';

/// Builds a line with animal and its infos like "Cat · 3 years · 4.8 kg" for a pet
/// Age and weight are skipped if they are unknown
String petSubtitle(Pet pet) {
  var text = speciesLabel(pet.species);

  final age = pet.ageInYears;
  if (age != null) {
    if (age == 1) {
      text = '$text · 1 year';
    } else {
      text = '$text · $age years';
    }
  }

  if (pet.weightKg != null) {
    text = '$text · ${pet.weightKg} kg';
  }

  return text;
}


/// Builds a line like "Tabby cat · 3 years" for the My pets list
/// If the breed is empty, the species name is used like "rabbit"
/// If the age is unknown, "Age not set" is shown
String petBreedAndAge(Pet pet) {
  // Breed is optional so  back to the species name
  String kind;
  if (pet.breed == null || pet.breed!.trim().isEmpty) {
    kind = speciesLabel(pet.species);
  } else {
    kind = pet.breed!;
  }

  final age = pet.ageInYears;
  String ageText;
  if (age == null) {
    ageText = 'Age not set';
  } else if (age == 1) {
    ageText = '1 year';
  } else {
    ageText = '$age years';
  }

  return '$kind · $ageText';
}