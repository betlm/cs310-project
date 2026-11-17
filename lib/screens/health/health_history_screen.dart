
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../data/app_state.dart';
import '../../widgets/active_profile_card.dart';
import '../../models/health_record.dart';
import '../../theme/species_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../data/sample_data.dart';

/// Bottom navigation tab: health.
/// Shown inside MainShell, so it has no back arrow.
class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() =>
      _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  HealthRecordType? selectedFilter;

  @override
  Widget build(BuildContext context) {
    final allRecords = healthRecordsFor(activePet.id);

    final records = selectedFilter == null
        ? allRecords
        : allRecords
            .where((record) => record.type == selectedFilter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health history'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Active pet profile
            ActiveProfileCard(
              petName: activePet.name,
              petType: speciesLabel(activePet.species),
              imageUrl: activePet.avatarPath,
            ),

            const SizedBox(height: 24),

            // Add health record button

            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.healthRecordForm,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.darkGreen,
                        size: 30,
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Health Record',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkGreen,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Keep track of your pet\'s health',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 12,
                                color: AppColors.darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.darkGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),

           

            const SizedBox(height: 12),

            // Weight tracking button
            
            Material(
              color: AppColors.lightMint,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.weightTracking,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.mintBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monitor_weight_outlined,
                        color: AppColors.darkGreen,
                        size: 30,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weight Tracking',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Monitor your pet\'s weight',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.darkGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),


            const SizedBox(height: 24),

            // Health record filters
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: selectedFilter == null,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = null;
                      });
                    },
                  ),

                  const SizedBox(width: 8),

                  ...HealthRecordType.values.map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          switch (type) {
                            HealthRecordType.vetVisit => 'Vet Visit',
                            HealthRecordType.checkUp => 'Check Up',
                            HealthRecordType.parasiteTreatment =>
                              'Parasite Treatment',
                            HealthRecordType.feedingNote => 'Feeding Note',
                            _ => type.name[0].toUpperCase() +
                                type.name.substring(1),
                          },
                        ),
                        selected: selectedFilter == type,
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = type;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            
            // Health records list
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  final recordIcon = switch (record.type) {
                    HealthRecordType.vaccination => Icons.vaccines_outlined,
                    HealthRecordType.vetVisit => Icons.local_hospital_outlined,
                    HealthRecordType.checkUp => Icons.medical_services_outlined,
                    HealthRecordType.medication => Icons.medication_outlined,
                    HealthRecordType.parasiteTreatment => Icons.bug_report_outlined,
                    HealthRecordType.feedingNote => Icons.restaurant_outlined,
                    HealthRecordType.other => Icons.notes_outlined,
                  };

                  final dateText =
                      '${record.date.day} ${[
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                  ][record.date.month - 1]} ${record.date.year}';

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline dot and vertical line
                      SizedBox(
                        width: 20,
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 130,
                              color: AppColors.mintBorder,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      
                      // Health record card
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date above the card
                            Text(
                              dateText,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Record title and icon
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors.lightMint,
                                          child: Icon(
                                            recordIcon,
                                            color: AppColors.darkGreen,
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: Text(
                                            record.title,
                                            style: AppTextStyles.bodyLarge.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),

                                        // Edit button
                                        IconButton(
                                          tooltip: 'Edit record',
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                        ),

                                        // Delete button
                                        IconButton(
                                          tooltip: 'Delete record',
                                          onPressed: () async {
                                            final shouldDelete = await showDialog<bool>(
                                              context: context,
                                              builder: (dialogContext) {
                                                return AlertDialog(
                                                  title: const Text('Delete health record?'),
                                                  content: Text(
                                                    'Are you sure you want to delete "${record.title}"?',
                                                  ),
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
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(color: AppColors.danger),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (shouldDelete == true && mounted) {
                                              setState(() {
                                                sampleHealthRecords.removeWhere(
                                                  (item) => item.id == record.id,
                                                );
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: AppColors.danger,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                                                      

                                    // Record notes
                                    if (record.notes != null &&
                                        record.notes!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        record.notes!,
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
