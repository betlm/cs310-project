/// The species options shown as cards in the Create / edit pet form.
enum PetSpecies { cat, dog, bird, fish, rabbit, hamster }

/// Sex options for a pet and "unknown" is the default.
enum PetSex { male, female, unknown }

/// A single pet profile.
///
/// Only name and species are required; every other field is optional,matching the wireframe's Create / edit pet form.
class Pet {
  final String id;
  final String name;
  final PetSpecies species;
  final String? breed;
  final DateTime? birthDate;
  final int? approximateAgeYears;
  final PetSex sex;
  final double? weightKg;
  final String? microchipNumber;
  final String? tagInfo;
  final String? avatarAsset; // local image, 

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    this.breed,
    this.birthDate,
    this.approximateAgeYears,
    this.sex = PetSex.unknown,
    this.weightKg,
    this.microchipNumber,
    this.tagInfo,
    this.avatarAsset,
  });

  /// Age in whole years, calculated from the birth date if it exists,
  /// otherwise taken from the approximate age
  int? get ageInYears {
    if (birthDate != null) {
      final now = DateTime.now();
      int age = now.year - birthDate!.year;
      // Subtract one year if this year's birthday hasn't happened yet
      if (now.month < birthDate!.month ||
          (now.month == birthDate!.month && now.day < birthDate!.day)) {
        age--;
      }
      return age;
    }
    return approximateAgeYears;
  }
}