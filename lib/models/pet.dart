import 'dart:io';

import 'package:flutter/material.dart';
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
  final String? photoPath; // photo picked from the gallery in the pet form

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
    this.photoPath,
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

    /// Local image to show for this pet.
  ///
  /// Uses [avatarAsset] if one was chosen, otherwise the default image for
  /// the species (e.g. 'assets/images/default-cat.png').
  String get avatarPath =>
      avatarAsset ?? 'assets/images/default-${species.name}.png';

  
  /// Image to show in avatars: the picked photo if there is one otherwise the local avatar image.
  ImageProvider get avatarImage {
    if (photoPath != null) {
      return FileImage(File(photoPath!));
    }
    return AssetImage(avatarPath);
  }
}
