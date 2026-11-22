import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/weight_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_format.dart';
import '../../widgets/active_pet_bar.dart';
import '../../widgets/square_icon_button.dart';
import '../../widgets/confirm_dialog.dart';
import 'weight_entry_form_sheet.dart';
import 'widgets/weight_chart.dart';
import '../../widgets/pet_switcher_sheet.dart';
import '../../l10n/app_strings.dart';

class WeightTrackingScreen extends StatefulWidget {
  const WeightTrackingScreen({super.key});

  @override
  State<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends State<WeightTrackingScreen> {
  List<WeightEntry> get _entries {
    final entries = weightEntriesFor(activePet.id).toList();
    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  String _weight(double value) => value.toStringAsFixed(1);

  // Select an active pet using the existing shared pet chips.
  Future<void> _selectPet() async {
    await showPetSwitcher(context);

    if (!mounted) return;

    setState(() {});
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
   final confirmed = await showConfirmDialog(
    context: context,
    title: AppStrings.get('deleteWeightTitle'),
    message: AppStrings.get('deleteWeightMessage'),
    confirmText: AppStrings.get('delete'),
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
        final oldestWeight = previous.first.weightKg;
        change = latest.weightKg - oldestWeight;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightMint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          
          if (latest == null)
            Text(
              AppStrings.get('noEntriesYet'),
              style: AppTextStyles.headingSmall,
            )
          else
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _weight(latest.weightKg),
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 36,
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
          const SizedBox(height: 2),
          Text(
            change == null
                ? AppStrings.get('trackWeightSubtitle')
                : AppStrings.get('weightChangeLast3').replaceAll(
                    '{change}',
                    '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}',
                  ),
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 1.5),
            gradient: LinearGradient(
              colors: [AppColors.lightMint, AppColors.background],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add, color: AppColors.darkGreen, size: 24),
              ),
              
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('addWeightEntry'),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.get('addWeightSubtitle'),
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
              Icon(Icons.chevron_right, color: AppColors.darkGreen, size: 24),
            ],
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
          AppStrings.get('recentEntries'),
          style: AppTextStyles.headingMedium.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppStrings.get('noWeightEntries'),
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ...recent.map(
          (entry) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 1.5,
              ),
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
                          fontSize: 14,
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
                SquareIconButton(
                  icon: Icons.edit_outlined,
                  color: AppColors.darkGreen,
                  size: 34,
                  onTap: () => _openForm(entry),
                ),
                const SizedBox(width: 6),
                SquareIconButton(
                  icon: Icons.delete_outline,
                  color: AppColors.danger,
                  size: 34,
                  onTap: () => _deleteEntry(entry),
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
          AppStrings.get('weightTracking'),
          style: AppTextStyles.headingMedium.copyWith(
            fontSize: 20,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ActivePetBar(pet: activePet, onTap: _selectPet),
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
