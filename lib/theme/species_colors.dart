import 'dart:ui';

import '../models/pet.dart';
import 'app_colors.dart';

/// Background color used for each species
/// (pet avatars and the active pet card on Home).
Color speciesColor(PetSpecies species) => switch (species) {
      PetSpecies.cat => AppColors.speciesCat,
      PetSpecies.dog => AppColors.speciesDog,
      PetSpecies.bird => AppColors.speciesBird,
      PetSpecies.fish => AppColors.speciesFish,
      PetSpecies.rabbit => AppColors.speciesRabbit,
      PetSpecies.hamster => AppColors.speciesHamster,
    };