import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../models/pet.dart';
import '../../theme/app_spacing.dart';
import 'widgets/active_pet_card.dart';
import 'widgets/home_header.dart';
import 'widgets/latest_weight_card.dart';
import 'widgets/pet_chips_row.dart';
import 'widgets/summary_grid.dart';
import 'widgets/upcoming_reminder_section.dart';
import '../../routes/app_routes.dart';

/// Bottom navigation tab: Home.
/// Shown inside MainShell, so it has no back arrow.
///
/// Summarizes the active pet: profile, upcoming reminder,
/// health/supplies/photos/reminders counts and latest weight.
class HomeScreen extends StatefulWidget {
  /// Called when the Health card is tapped. MainShell uses it to
  /// switch to the Health tab.
  final VoidCallback onOpenHealth;

  const HomeScreen({super.key, required this.onOpenHealth});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Makes [pet] the active pet and rebuilds Home with its data.
  void _selectPet(Pet pet) {
    setState(() {
      activePet = pet;
    });
  }

  /// Opens another screen. When the user comes back, Home rebuilds,
  /// because something may have been added or deleted on that screen.
  Future<void> _openScreen(String routeName) async {
    await Navigator.pushNamed(context, routeName);
    // The screen may have been closed while we were waiting.
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pet = activePet;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md + AppSpacing.xs, // 20
            vertical: AppSpacing.md,
          ),
          children: [
            const HomeHeader(),
            const SizedBox(height: AppSpacing.md),
            PetChipsRow(
              selectedPet: pet,
              onPetSelected: _selectPet,
              onAddPet: () => _openScreen(AppRoutes.petForm),
            ),
            const SizedBox(height: AppSpacing.md),
            ActivePetCard(
              pet: pet,
              onTap: () => _openScreen(AppRoutes.petDetails),
            ),
            const SizedBox(height: AppSpacing.lg),
            UpcomingReminderSection(
              reminder: nextReminderFor(pet.id),
              onOpenReminders: () => _openScreen(AppRoutes.reminders),
            ),
            const SizedBox(height: AppSpacing.md),
            SummaryGrid(
              petId: pet.id,
              onOpenHealth: widget.onOpenHealth,
              onOpenScreen: _openScreen,
            ),
            const SizedBox(height: AppSpacing.md),
            LatestWeightCard(
              entries: weightEntriesFor(pet.id),
              onTap: () => _openScreen(AppRoutes.weightTracking),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}