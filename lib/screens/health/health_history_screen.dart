import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/health_record.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'health_record_form_screen.dart';
import '../../widgets/active_pet_bar.dart';
import '../../widgets/pet_switcher_sheet.dart';
import '../../widgets/square_icon_button.dart';
import '../../widgets/confirm_dialog.dart';
import '../../utils/date_format.dart';
import '../../l10n/app_strings.dart';
import '../../utils/sample_localization.dart';
import '../../theme/health_record_colors.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  HealthRecordType? selectedFilter;

  Future<void> _selectPet() async {
    await showPetSwitcher(context);

    if (!mounted) return;

    setState(() {
      selectedFilter = null;
    });
  }

  String _typeLabel(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.vaccination => AppStrings.get('vaccination'),
      HealthRecordType.vetVisit => AppStrings.get('vetVisit'),
      HealthRecordType.checkUp => AppStrings.get('checkUp'),
      HealthRecordType.medication => AppStrings.get('medication'),
      HealthRecordType.parasiteTreatment => AppStrings.get('parasiteTreatment'),
      HealthRecordType.feedingNote => AppStrings.get('feedingNotes'),
      HealthRecordType.other => AppStrings.get('other'),
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
    final shouldDelete = await showConfirmDialog(
      context: context,
      title: AppStrings.get('deleteRecordTitle').replaceAll(
        '{title}',
        SampleLocalization.text(
          id: record.id,
          field: 'title',
          value: record.title,
        ),
      ),
      message: AppStrings.get('deleteRecordMessage'),
      confirmText: AppStrings.get('delete'),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.lightMint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
              child: Icon(icon, color: AppColors.darkGreen, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.darkGreen),
          ],
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
            label: AppStrings.get('all'),
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

  Widget _recordTimelineItem(HealthRecord record) {
    final color = healthRecordColor(record.type);
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
                    formatDate(record.date),
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
                                          SampleLocalization.text(
                                            id: record.id,
                                            field: 'title',
                                            value: record.title,
                                          ),
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                                fontFamily: 'Manrope',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.darkGreen,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SquareIconButton(
                                      icon: Icons.edit_outlined,
                                      color: AppColors.darkGreen,
                                      onTap: () async {
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
                                    SquareIconButton(
                                      icon: Icons.delete_outline,
                                      color: AppColors.danger,
                                      onTap: () {
                                        _deleteRecord(record);
                                      },
                                    ),
                                  ],
                                ),
                                if (record.notes != null &&
                                    record.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 7),
                                  Text(
                                    SampleLocalization.text(
                                      id: record.id,
                                      field: 'notes',
                                      value: record.notes!,
                                    ),
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
          AppStrings.get('healthHistory'),
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
          _actionCard(
            title: AppStrings.get('addHealthRecord'),
            subtitle: AppStrings.get('addHealthRecordSubtitle'),
            icon: Icons.add,
            onTap: _openAddRecord,
          ),
          const SizedBox(height: 14),
          _actionCard(
            title: AppStrings.get('weightTrackingCard'),
            subtitle: AppStrings.get('weightTrackingCardSubtitle'),
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
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(20),
                color: AppColors.primary.withValues(alpha: 0.35),
                strokeWidth: 1.5,
                dashPattern: const [6, 5],
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightMint.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 1.5,
                        color: AppColors.fieldBorder,
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.lightMint,
                          child: Icon(
                            Icons.favorite_border,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          AppStrings.get('noHealthRecords'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingSmall.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.get('noHealthRecordsMessage')
                              .replaceAll('{name}', activePet.name),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
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
