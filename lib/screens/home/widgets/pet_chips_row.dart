import 'package:flutter/material.dart';

import '../../../data/app_state.dart';
import '../../../data/sample_data.dart';
import '../../../models/pet.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

/// Horizontal row of pet avatars at the top of Home.
///
/// Tapping a pet makes it the active pet; the last item opens
/// the Create pet form.
class PetChipsRow extends StatelessWidget {
  /// The pet that is currently active, shown with a highlighted ring.
  final Pet selectedPet;

  const PetChipsRow({super.key, required this.selectedPet});

  @override
  Widget build(BuildContext context) {
    // Fixed height so the horizontal list can sit inside the vertical ListView.
    return SizedBox(
      height: 108,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final pet in samplePets)
            _PetChip(
              pet: pet,
              isSelected: pet.id == selectedPet.id,
              onTap: () => selectPet(pet),
            ),
          _AddPetChip(
            onTap: () => Navigator.pushNamed(context, AppRoutes.petForm),
          ),
        ],
      ),
    );
  }
}

/// One pet avatar with its name underneath.
class _PetChip extends StatelessWidget {
  final Pet pet;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetChip({
    required this.pet,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            // Ring around the avatar; visible only for the active pet.
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.lightMint,
                backgroundImage: AssetImage(pet.avatarPath),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              pet.name,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onSurface
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The "Add pet" circle at the end of the row.
class _AddPetChip extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPetChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // gesture detectore widgeti tıklanabilir yapar
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Icon(Icons.add, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Add pet', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}