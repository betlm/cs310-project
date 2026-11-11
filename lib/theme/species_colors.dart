import 'package:flutter/material.dart';

import '../models/pet.dart';
import 'app_colors.dart';

/// Background color used for each species (pet avatars and the active pet card on Home).
Color speciesColor(PetSpecies species) {
  switch (species) {
    case PetSpecies.cat:
      return AppColors.speciesCat;
    case PetSpecies.dog:
      return AppColors.speciesDog;
    case PetSpecies.bird:
      return AppColors.speciesBird;
    case PetSpecies.fish:
      return AppColors.speciesFish;
    case PetSpecies.rabbit:
      return AppColors.speciesRabbit;
    case PetSpecies.hamster:
      return AppColors.speciesHamster;
  }
}