import 'package:flutter/material.dart';

import '../../../models/pet.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/species_colors.dart';

/// Large card on Home showing the active pet's avatar, name,
/// species, age and weight. Its color depends on the pet's species.
/// Tapping it opens the pet's details.
class ActivePetCard extends StatelessWidget {
  final Pet pet;

  const ActivePetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(18);
    final cardColor = speciesColor(pet.species);

    // DecoratedBox draws the shadow; Material + InkWell give the color,
    // rounded corners and the ripple effect when tapped.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: cardColor,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () => Navigator.pushNamed(context, AppRoutes.petDetails),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
            child: Row(
              children: [
                _HeroAvatar(pet: pet, background: cardColor),
                const SizedBox(width: AppSpacing.sm + AppSpacing.xs), // 12
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE PET',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 9,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGreen.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pet.name,
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      Text(
                        _subtitle(pet),
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs + 2), // 6
                      // "View profile" pill: faded, semi-transparent cream.
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'View profile',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.darkGreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a line like "Cat · 3 years · 4.8 kg".
  /// Age and weight are skipped if they are unknown.
  static String _subtitle(Pet pet) {
    final parts = <String>[_speciesLabel(pet.species)];

    final age = pet.ageInYears;
    if (age != null) parts.add(age == 1 ? '1 year' : '$age years');

    if (pet.weightKg != null) parts.add('${pet.weightKg} kg');

    return parts.join(' · ');
  }

  /// Display name of each species.
  static String _speciesLabel(PetSpecies species) => switch (species) {
        PetSpecies.cat => 'Cat',
        PetSpecies.dog => 'Dog',
        PetSpecies.bird => 'Bird',
        PetSpecies.fish => 'Fish',
        PetSpecies.rabbit => 'Rabbit',
        PetSpecies.hamster => 'Hamster',
      };
}

/// Round avatar with a soft cream border and a small shadow.
class _HeroAvatar extends StatelessWidget {
  final Pet pet;
  final Color background;

  const _HeroAvatar({required this.pet, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.82),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      // ClipOval cuts the square image into a circle.
      child: ClipOval(
        child: Image.asset(pet.avatarPath, fit: BoxFit.cover),
      ),
    );
  }
}