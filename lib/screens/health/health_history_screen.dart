import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/health_record.dart';
import '../../models/pet.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/species_colors.dart';
import '../../widgets/active_profile_card.dart';
import '../home/widgets/pet_chips_row.dart';
import 'health_record_form_screen.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  HealthRecordType? selectedFilter;

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
                  'Choose whose health records to view',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 20),
                PetChipsRow(
                  selectedPet: activePet,
                  onPetSelected: (Pet pet) {
                    setState(() {
                      activePet = pet;
                      selectedFilter = null;
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

  String _typeLabel(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.vaccination => 'Vaccination',
      HealthRecordType.vetVisit => 'Vet visit',
      HealthRecordType.checkUp => 'Check-up',
      HealthRecordType.medication => 'Medication',
      HealthRecordType.parasiteTreatment => 'Parasite treatment',
      HealthRecordType.feedingNote => 'Feeding notes',
      HealthRecordType.other => 'Other',
    };
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Color _recordColor(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.checkUp => AppColors.peach,
      HealthRecordType.vaccination => AppColors.primary,
      HealthRecordType.medication => AppColors.darkGreen,
      HealthRecordType.vetVisit => AppColors.peach,
      HealthRecordType.parasiteTreatment => AppColors.primary,
      HealthRecordType.feedingNote => AppColors.primary,
      HealthRecordType.other => AppColors.darkGreen,
    };
  }

  IconData _recordIcon(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.checkUp => Icons.favorite_border,
      HealthRecordType.vaccination => Icons.event_outlined,
      HealthRecordType.medication => Icons.notifications_none,
      HealthRecordType.vetVisit => Icons.medical_services_outlined,
      HealthRecordType.parasiteTreatment => Icons.shield_outlined,
      HealthRecordType.feedingNote => Icons.restaurant_outlined,
      HealthRecordType.other => Icons.notes_outlined,
    };
  }

  Future<void> _openAddRecord() async {
    await Navigator.pushNamed(context, AppRoutes.healthRecordForm);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteRecord(HealthRecord record) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete health record?'),
          content: Text('Are you sure you want to delete "${record.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(
                'Delete',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && mounted) {
      setState(() {
        sampleHealthRecords.removeWhere((item) => item.id == record.id);
      });
    }
  }

  Widget _actionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
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
                child: Icon(icon, color: AppColors.darkGreen, size: 27),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: AppColors.secondaryText,
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

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.fieldBorder,
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? AppColors.darkGreen
                      : AppColors.secondaryText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterRow() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        primary: false,
        padding: EdgeInsets.zero,
        children: [
          _filterChip(
            label: 'All',
            selected: selectedFilter == null,
            onTap: () {
              setState(() {
                selectedFilter = null;
              });
            },
          ),
          ...HealthRecordType.values.map((type) {
            return _filterChip(
              label: _typeLabel(type),
              selected: selectedFilter == type,
              onTap: () {
                setState(() {
                  selectedFilter = type;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _recordActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
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
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.fieldBorder, width: 1.2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
        ),
      ),
    );
  }

  Widget _recordTimelineItem(HealthRecord record) {
    final color = _recordColor(record.type);
    final icon = _recordIcon(record.type);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 46,
            child: Column(
              children: [
                const SizedBox(height: 37),
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 1.5,
                          color: AppColors.fieldBorder,
                        ),
                      ),
                      Container(
                        width: 39,
                        height: 39,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 23,
                          color: record.type == HealthRecordType.medication
                              ? AppColors.white
                              : AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(record.date),
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 19),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.fieldBorder,
                        width: 1.3,
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 5,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          record.title,
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.darkGreen,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    _recordActionButton(
                                      icon: Icons.edit_outlined,
                                      color: AppColors.darkGreen,
                                      tooltip: 'Edit record',
                                      onPressed: () async {
                                        final updated =
                                            await Navigator.push<bool>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    HealthRecordFormScreen(
                                                      record: record,
                                                    ),
                                              ),
                                            );

                                        if (updated == true && mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    _recordActionButton(
                                      icon: Icons.delete_outline,
                                      color: AppColors.danger,
                                      tooltip: 'Delete record',
                                      onPressed: () {
                                        _deleteRecord(record);
                                      },
                                    ),
                                  ],
                                ),
                                if (record.notes != null &&
                                    record.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 7),
                                  Text(
                                    record.notes!,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allRecords = healthRecordsFor(activePet.id);

    final records = selectedFilter == null
        ? allRecords
        : allRecords.where((record) => record.type == selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appBar,
        elevation: 0,
        title: Text(
          'Health history',
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
          _actionCard(
            title: 'Add health record',
            subtitle: 'Record a vaccination, treatment, or visit',
            icon: Icons.add,
            onTap: _openAddRecord,
          ),
          const SizedBox(height: 14),
          _actionCard(
            title: 'Weight Tracking',
            subtitle: '4.8 kg · View chart and recent entries',
            icon: Icons.monitor_weight_outlined,
            onTap: () async {
              await Navigator.pushNamed(context, AppRoutes.weightTracking);

              if (mounted) {
                setState(() {});
              }
            },
          ),
          const SizedBox(height: 20),
          _filterRow(),
          const SizedBox(height: 24),
          if (records.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No health records yet.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            )
          else
            ...records.map(_recordTimelineItem),
        ],
      ),
    );
  }
}
