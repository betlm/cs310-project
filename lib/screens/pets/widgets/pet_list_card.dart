import 'package:flutter/material.dart';

import '../../../models/pet.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/species_colors.dart';
import '../../../utils/pet_format.dart';
import '../../../widgets/square_icon_button.dart';
import '../../../l10n/app_strings.dart';

/// One pet in the My pets list: avatar, name, breed and age,
/// an "Active profile" line for the active pet, and edit / delete buttons
class PetListCard extends StatelessWidget {
  final Pet pet;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PetListCard({
    super.key,
    required this.pet,
    required this.isActive,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // The active pet's card is mint with a thicker green border
    Color backgroundColor;
    Color borderColor;
    double borderWidth;
    if (isActive) {
      backgroundColor = AppColors.lightMint;
      borderColor = AppColors.primary;
      borderWidth = 2;
    } else {
      backgroundColor = AppColors.white;
      borderColor = AppColors.cardBorder;
      borderWidth = 1.5;
    }

    // Name and breed / age, plus "Active profile" for the active pet
    final textLines = <Widget>[
      Text(
        pet.name,
        overflow: TextOverflow.ellipsis,
        style:  TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.darkGreen,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        petBreedAndAge(pet),
        overflow: TextOverflow.ellipsis,
        style:  TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.secondaryText,
        ),
      ),
    ];

    if (isActive) {
      textLines.add(const SizedBox(height: 6));
      textLines.add(
         Row(
          children: [
            Icon(Icons.check, size: 14, color: AppColors.darkGreen),
            SizedBox(width: AppSpacing.xs),
            Text(
              AppStrings.get('activeProfile'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              // Avatar with a thin white ring around it
              Container(
                padding: const EdgeInsets.all(2),
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: speciesColor(pet.species),
                  backgroundImage: pet.avatarImage,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: textLines,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SquareIconButton(
                icon: Icons.edit_outlined,
                color: AppColors.darkGreen,
                onTap: onEdit,
              ),
              const SizedBox(width: AppSpacing.sm),
              SquareIconButton(
                icon: Icons.delete_outline,
                color: AppColors.danger,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

