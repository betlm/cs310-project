import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/pet.dart';
import '../../models/weight_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/species_colors.dart';
import '../../utils/date_format.dart';
import '../../widgets/active_profile_card.dart';

import '../home/widgets/pet_chips_row.dart';
import 'weight_entry_form_sheet.dart';
import 'widgets/weight_chart.dart';

class WeightTrackingScreen extends StatefulWidget {
  const WeightTrackingScreen({super.key});

  @override
  State<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends State<WeightTrackingScreen> {
  List<WeightEntry> get _entries => weightEntriesFor(activePet.id);

  String _weight(double value) => value.toStringAsFixed(1);

  // Select an active pet using the existing shared pet chips.
  Future<void> _selectPet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a pet',
                  style: AppTextStyles.headingMedium.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose whose weight history to view',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 20),
                PetChipsRow(
                  selectedPet: activePet,
                  onPetSelected: (Pet pet) {
                    setState(() {
                      activePet = pet;
                    });

                    Navigator.pop(sheetContext);
                  },
                  onAddPet: () {
                    Navigator.pop(sheetContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'You can add a new pet from the Pets tab.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Open the form for adding or editing a weight entry.
  Future<void> _openForm([WeightEntry? entry]) async {
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WeightEntryFormSheet(petId: activePet.id, entry: entry),
    );

    if (changed == true && mounted) {
      setState(() {});
    }
  }

  // Delete a weight entry after confirmation.
  Future<void> _deleteEntry(WeightEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('Delete weight entry?', style: AppTextStyles.headingSmall),
        content: Text(
          'Are you sure you want to delete this entry?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: AppTextStyles.bodyMedium),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Delete',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        sampleWeightEntries.removeWhere((item) => item.id == entry.id);
      });
    }
  }

  // Current weight card.
  Widget _currentWeightCard(List<WeightEntry> entries) {
    final latest = entries.isEmpty ? null : entries.last;
    double? change;

    if (latest != null) {
      final start = DateTime(
        latest.date.year,
        latest.date.month - 3,
        latest.date.day,
      );

      final previous = entries
          .where(
            (entry) =>
                !entry.date.isBefore(start) && !entry.date.isAfter(latest.date),
          )
          .toList();

      if (previous.length >= 2) {
        change = latest.weightKg - previous.first.weightKg;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.lightMint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            'Current weight',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (latest == null)
            Text('No entries yet', style: AppTextStyles.headingSmall)
          else
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _weight(latest.weightKg),
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: ' kg',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 5),
          Text(
            change == null
                ? 'Track your pet’s weight over time'
                : '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} kg in the last 3 months',
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  // Add weight entry card.
  Widget _addWeightCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openForm(),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.mintBorder, width: 1.3),
            gradient:  LinearGradient(
              colors: [AppColors.lightMint, AppColors.background],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(13),
                ),
                child:  Icon(
                  Icons.add,
                  color: AppColors.darkGreen,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add weight entry',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keep the growth chart up to date',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
               Icon(
                Icons.chevron_right,
                color: AppColors.darkGreen,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable edit/delete action button.
  Widget _actionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.fieldBorder, width: 1.2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 19, color: color?? AppColors.darkGreen),
          ),
        ),
      ),
    );
  }

  // Recent weight entries list.
  Widget _recentEntries(List<WeightEntry> entries) {
    final recent = entries.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent entries',
          style: AppTextStyles.headingMedium.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No weight entries yet.',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ...recent.map(
          (entry) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_weight(entry.weightKg)} kg',
                        style: AppTextStyles.headingSmall.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatDate(entry.date),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _actionButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit weight',
                  onPressed: () => _openForm(entry),
                ),
                const SizedBox(width: 5),
                _actionButton(
                  icon: Icons.delete_outline,
                  tooltip: 'Delete weight',
                  color: AppColors.danger,
                  onPressed: () => _deleteEntry(entry),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appBar,
        elevation: 0,
        title: Text(
          'Weight tracking',
          style: AppTextStyles.headingMedium.copyWith(
            fontSize: 20,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ActiveProfileCard(
            petName: activePet.name,
            petType: speciesLabel(activePet.species),
            imageUrl: activePet.avatarPath,
            onTap: _selectPet,
          ),
          const SizedBox(height: 30),
          _currentWeightCard(entries),
          const SizedBox(height: 14),
          _addWeightCard(),
          const SizedBox(height: 14),

          // Chart is now a separate widget.
          WeightChart(entries: entries),

          const SizedBox(height: 24),
          _recentEntries(entries),
        ],
      ),
    );
  }
}
