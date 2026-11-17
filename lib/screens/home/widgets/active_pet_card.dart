import 'package:flutter/material.dart';

import '../../../models/pet.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/species_colors.dart';
import '../../../utils/pet_format.dart';

/// Large card on Home showing the active pet's avatar, name,
/// species, age and weight. Its color depends on the pet's species.
class ActivePetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const ActivePetCard({
    super.key,
    required this.pet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = speciesColor(pet.species);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with a thin cream border around it.
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.avatarBorder,
              ),
              child: CircleAvatar(
                radius: 46,
                backgroundColor: cardColor,
                backgroundImage: AssetImage(pet.avatarPath),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs), // 12
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACTIVE PET',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      color: AppColors.activePetLabel,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  Text(
                    petSubtitle(pet),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs + 2), // 6
                  // "View profile" pill.
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.viewProfileBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'View profile',
                      style: TextStyle(
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
    );
  }
}