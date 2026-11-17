
import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../data/app_state.dart';
import '../../widgets/active_profile_card.dart';
import '../../widgets/primary_button.dart';
import '../../models/health_record.dart';

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
              petType: activePet.species.name,
              imageUrl: activePet.avatarPath,
            ),

            const SizedBox(height: 24),

            // Add health record button
            PrimaryButton(
              text: 'Add Health Record',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.healthRecordForm,
                );
              },
            ),

            const SizedBox(height: 12),

            // Weight tracking button
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.weightTracking,
                );
              },
              icon: const Icon(Icons.monitor_weight_outlined),
              label: const Text('Weight Tracking'),
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

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.medical_services_outlined),
                      ),
                      title: Text(record.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(record.type.name),
                          Text(
                            '${record.date.day}/${record.date.month}/${record.date.year}',
                          ),
                        ],
                      ),
                    ),
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
