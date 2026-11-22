import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../routes/app_routes.dart';
import '../screens/home/widgets/pet_chips_row.dart';
import '../theme/app_colors.dart';
import '../l10n/app_strings.dart';

/// Opens a sheet from the bottom where the user can choose the active pet or tap "Add pet" to open the Create pet form
/// Use it with await and refresh the screen afterwards
///   await showPetSwitcher(context);
///   if (!mounted) return;
///   setState(() {});
Future<void> showPetSwitcher(BuildContext context) async {
  // Set to true when "Add pet" is tapped, so the form opens after the sheet has closed
  var openPetForm = false;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                AppStrings.get('selectPet'),
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 16),
              PetChipsRow(
                selectedPet: activePet,
                onPetSelected: (pet) {
                  activePet = pet;
                  Navigator.pop(sheetContext);
                },
                onAddPet: () {
                  openPetForm = true;
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  if (openPetForm && context.mounted) {
    await Navigator.pushNamed(context, AppRoutes.petForm);
  }
}