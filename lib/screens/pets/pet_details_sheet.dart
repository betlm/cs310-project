import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/pet.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/species_colors.dart';
import '../../widgets/confirm_dialog.dart';

/// pet's profile in sheet from the bottom
/// avatar, name, species and breed, age, weight, microchip, tag,
/// and Edit / Delete buttons
///
/// the pet may have been edited or deleted:
///   await showPetDetails(context, pet);
///   if (!mounted) return;
///   setState(() {});
Future<void> showPetDetails(BuildContext context, Pet pet) async {
  // Which button was pressed: 'edit', 'delete' or null (sheet closed)
  String? action;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.white,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return _PetDetailsContent(
        pet: pet,
        onEdit: () {
          action = 'edit';
          Navigator.pop(sheetContext);
        },
        onDelete: () {
          action = 'delete';
          Navigator.pop(sheetContext);
        },
      );
    },
  );

  // The sheet is closed now; do what the button asked for
  if (!context.mounted) return;

  if (action == 'edit') {
    await Navigator.pushNamed(context, AppRoutes.petForm, arguments: pet);
  } else if (action == 'delete') {
    await confirmAndDeletePet(context, pet);
  }
}

/// Asks for confirmation, then deletes the pet with all its records
/// The last pet cannot be deleted, because Home always needs one
Future<void> confirmAndDeletePet(BuildContext context, Pet pet) async {
  if (samplePets.length == 1) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You need at least one pet.')),
    );
    return;
  }

  final ok = await showConfirmDialog(
    context: context,
    title: 'Delete ${pet.name}?',
    message: 'All reminders, health records, weights, supplies and '
        'photos of ${pet.name} will be removed too.',
    confirmText: 'Delete',
  );

  if (!ok || !context.mounted) return;

  deletePet(pet);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${pet.name} was deleted.')),
  );
}

/// class
class _PetDetailsContent extends StatelessWidget {
  final Pet pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PetDetailsContent({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  /// "Cat · Tabby cat", or just "Cat" if there is no breed
  static String _speciesAndBreed(Pet pet) {
    final species = speciesLabel(pet.species);
    final breed = pet.breed?.trim() ?? '';
    if (breed.isEmpty) {
      return species;
    }
    return '$species · $breed';
  }

  /// "3 years", "1 year" or "Not set"
  static String _ageText(Pet pet) {
    final age = pet.ageInYears;
    if (age == null) return 'Not set';
    if (age == 1) return '1 year';
    return '$age years';
  }

  /// Shows "Not set" for empty optional values
  static String _orNotSet(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Not set';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    String weightText = 'Not set';
    if (pet.weightKg != null) {
      weightText = '${pet.weightKg} kg';
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar, name and species / breed
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightMint,
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: speciesColor(pet.species),
                    backgroundImage: AssetImage(pet.avatarPath),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _speciesAndBreed(pet),
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // 2 x 2 info boxes
            Row(
              children: [
                Expanded(child: _InfoBox(label: 'Age', value: _ageText(pet))),
                const SizedBox(width: 10),
                Expanded(child: _InfoBox(label: 'Weight', value: weightText)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _InfoBox(
                    label: 'Microchip',
                    value: _orNotSet(pet.microchipNumber),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _InfoBox(
                    label: 'Tag',
                    value: _orNotSet(pet.tagInfo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Edit and Delete buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGreen,
                      minimumSize: const Size(0, 46),
                      side:  BorderSide(
                        color: AppColors.mintBorder,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      minimumSize: const Size(0, 46),
                      side:  BorderSide(
                        color: AppColors.dangerLight,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small grey box with a label ("Age") and a value ("3 years").
class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:  TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}