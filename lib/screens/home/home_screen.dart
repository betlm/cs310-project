import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../models/pet.dart';
import '../../theme/app_spacing.dart';
import 'widgets/home_header.dart';
import 'widgets/pet_chips_row.dart';
import 'widgets/active_pet_card.dart';
import 'widgets/upcoming_reminder_section.dart';
import 'widgets/summary_grid.dart';
import 'widgets/latest_weight_card.dart';

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
        // Rebuilds when the active pet changes or any data is added/removed.
        child: ListenableBuilder(
          listenable: Listenable.merge([activePet, dataChanged]),
          builder: (context, _) {
            final pet = activePet.value;
            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md + AppSpacing.xs, // 20
                vertical: AppSpacing.md,
              ),
                  children: [
                const HomeHeader(),
                const SizedBox(height: AppSpacing.md),
                PetChipsRow(selectedPet: pet),
                const SizedBox(height: AppSpacing.md),
                ActivePetCard(pet: pet),
                const SizedBox(height: AppSpacing.lg),
                UpcomingReminderSection(reminder: nextReminderFor(pet.id)),
                const SizedBox(height: AppSpacing.md),
                SummaryGrid(petId: pet.id),
                const SizedBox(height: AppSpacing.md),
                LatestWeightCard(entries: weightEntriesFor(pet.id)),
                const SizedBox(height: AppSpacing.md),
              ],
            );
          },
        ),
      ),
    );
  }
}