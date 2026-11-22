import '../models/pet.dart';
import '../theme/species_colors.dart';
import '../l10n/app_strings.dart';
import 'sample_localization.dart';

/// Returns the translated species name.
String localizedSpeciesLabel(PetSpecies species) {
  final speciesName = speciesLabel(species).toLowerCase();

  switch (speciesName) {
    case 'cat':
      return AppStrings.get('cat');
    case 'dog':
      return AppStrings.get('dog');
    case 'bird':
      return AppStrings.get('bird');
    case 'fish':
      return AppStrings.get('fish');
    case 'rabbit':
      return AppStrings.get('rabbit');
    case 'hamster':
      return AppStrings.get('hamster');
    default:
      return speciesLabel(species);
  }
}

/// Builds a line like "Cat · 3 years · 4.8 kg".
String petSubtitle(Pet pet) {
  var text = localizedSpeciesLabel(pet.species);

  final age = pet.ageInYears;

  if (age != null) {
    if (age == 1) {
      text = '$text · ${AppStrings.get('oneYear')}';
    } else {
      text = '$text · $age ${AppStrings.get('years')}';
    }
  }

  if (pet.weightKg != null) {
    text = '$text · ${pet.weightKg} kg';
  }

  return text;
}

/// Builds a line like "Tabby cat · 3 years" for the My Pets list.
String petBreedAndAge(Pet pet) {
  String kind;

  if (pet.breed == null || pet.breed!.trim().isEmpty) {
    kind = localizedSpeciesLabel(pet.species);
  } else {
    kind = SampleLocalization.text(
      id: pet.id,
      field: 'breed',
      value: pet.breed!,
    );
  }

  final age = pet.ageInYears;
  String ageText;

  if (age == null) {
    ageText = AppStrings.get('ageNotSet');
  } else if (age == 1) {
    ageText = AppStrings.get('oneYear');
  } else {
    ageText = '$age ${AppStrings.get('years')}';
  }

  return '$kind · $ageText';
}
