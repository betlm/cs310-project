import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../models/pet.dart';
import '../../theme/app_spacing.dart';
import 'widgets/home_header.dart';
import 'widgets/pet_chips_row.dart';

/// Bottom navigation tab: Home.
/// Shown inside MainShell, so it has no back arrow.
///
/// Summarizes the active pet: profile, upcoming reminder,
/// health/supplies/photos/reminders counts and latest weight.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Rebuilds the whole screen whenever the active pet changes.
        child: ValueListenableBuilder<Pet>(
          valueListenable: activePet,
          builder: (context, pet, _) {
            return ListView(
              padding: AppSpacing.screenPadding,
                                          children: [
                const HomeHeader(),
                const SizedBox(height: AppSpacing.lg),
                PetChipsRow(selectedPet: pet),
                const SizedBox(height: AppSpacing.lg),

                // Temporary: shows that switching pets works.
                // Replaced by the active pet card in the next step.
                Text('Active pet: ${pet.name}'),
              ],
            );
          },
        ),
      ),
    );
  }
}