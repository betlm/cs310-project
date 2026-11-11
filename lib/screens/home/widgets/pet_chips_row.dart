import 'package:flutter/material.dart';

import '../../../data/sample_data.dart';
import '../../../models/pet.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/species_colors.dart';
import 'dart:math' as math;


/// Horizontal row of pet avatars at the top of Home.
///
/// Tapping a pet makes it the active pet; the last item opens
/// the Create pet form.
class PetChipsRow extends StatelessWidget {
  /// The pet that is currently active, shown with a highlighted ring.
  final Pet selectedPet;
  final void Function(Pet pet) onPetSelected;
  final VoidCallback onAddPet;

  const PetChipsRow({
    super.key,
    required this.selectedPet,
    required this.onPetSelected,
    required this.onAddPet,
  });
  @override
  Widget build(BuildContext context) {
    // Fixed height so the horizontal list can sit inside the vertical ListView.
    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // One chip per pet, plus the "Add pet" chip at the end.
        itemCount: samplePets.length + 1,
        itemBuilder: (context, index) {
          if (index == samplePets.length) {
            return _AddPetChip(onTap: onAddPet);
          }
          final pet = samplePets[index];
          return _PetChip(
            pet: pet,
            isSelected: pet.id == selectedPet.id,
            onTap: () => onPetSelected(pet),
          );
        },
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
                radius: 26,
                backgroundColor: speciesColor(pet.species),
                backgroundImage: AssetImage(pet.avatarPath),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              pet.name,
              style: textTheme.bodySmall?.copyWith(
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

/// The "Add pet" circle at the end of the row, with a dashed border.
/// The "Add pet" circle at the end of the row, with a dashed border.
class _AddPetChip extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPetChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Same outer size as a pet chip (avatar 52 + ring 12).
          SizedBox(
            width: 64,
            height: 64,
            // foregroundPainter draws the dashes ON TOP of the filled circle.
            child: CustomPaint(
              foregroundPainter: _DashedCirclePainter(color: AppColors.primary),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightMint,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.darkGreen,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Add pet', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Draws a dashed circle that fills the available space.
/// Flutter has no built-in dashed border, so the dashes are drawn as arcs.
class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashCount = 24;
    const strokeWidth = 1.5;
    // Each dash covers 60% of its slot; the rest is the gap.
    const dashFraction = 0.6;
    const slot = 2 * math.pi / dashCount;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(rect, i * slot, slot * dashFraction, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}

///The last part from AI because here is not covered on the lecture yet (dashed circle)