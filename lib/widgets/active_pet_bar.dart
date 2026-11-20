import 'package:flutter/material.dart';

import '../models/pet.dart';
import '../theme/app_colors.dart';
import '../theme/species_colors.dart';

/// Small "Active profile" card at the top of a screen, e.g. Supply list,
/// Reminders and Health. Shows the active pet; tapping it should open
/// the pet switcher:
///   ActivePetBar(pet: activePet, onTap: _changePet)

class ActivePetBar extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const ActivePetBar({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.lightMint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mintBorder, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: speciesColor(pet.species),
              backgroundImage: AssetImage(pet.avatarPath),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Active profile',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${pet.name} · ${speciesLabel(pet.species)}',
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
             Icon(Icons.chevron_right, color: AppColors.darkGreen, size: 22),
          ],
        ),
      ),
    );
  }
}