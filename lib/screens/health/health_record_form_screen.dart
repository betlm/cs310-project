import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/health_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_format.dart';
import '../../widgets/app_form_field.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/primary_button.dart';
import '../../l10n/app_strings.dart';
import '../../utils/sample_localization.dart';

class HealthRecordFormScreen extends StatefulWidget {
  final HealthRecord? record;

  const HealthRecordFormScreen({super.key, this.record});

  @override
  State<HealthRecordFormScreen> createState() => _HealthRecordFormScreenState();
}

class _HealthRecordFormScreenState extends State<HealthRecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _imagePicker = ImagePicker();

  static const int _maxImageBytes = 10 * 1024 * 1024;

  HealthRecordType _selectedType = HealthRecordType.vaccination;
  DateTime _selectedDate = DateTime.now();
  bool _isTypeMenuOpen = false;
  bool _isPickingPhoto = false;
  XFile? _selectedPhoto;

  @override
  void initState() {
    super.initState();

    final record = widget.record;

    if (record != null) {
      _selectedType = record.type;
      _selectedDate = record.date;

      _titleController.text = SampleLocalization.text(
        id: record.id,
        field: 'title',
        value: record.title,
      );

      _notesController.text = record.notes == null
          ? ''
          : SampleLocalization.text(
              id: record.id,
              field: 'notes',
              value: record.notes!,
            );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _typeLabel(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.vaccination => AppStrings.get('vaccination'),
      HealthRecordType.vetVisit => AppStrings.get('vetVisit'),
      HealthRecordType.checkUp => AppStrings.get('checkUp'),
      HealthRecordType.medication => AppStrings.get('medication'),
      HealthRecordType.parasiteTreatment => AppStrings.get('parasiteTreatment'),
      HealthRecordType.feedingNote => AppStrings.get('feedingNote'),
      HealthRecordType.other => AppStrings.get('other'),
    };
  }

  Color _typeColor(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.vaccination => AppColors.primary,
      HealthRecordType.vetVisit => AppColors.speciesHamster,
      HealthRecordType.checkUp => AppColors.peach,
      HealthRecordType.medication => AppColors.darkGreen,
      HealthRecordType.parasiteTreatment => AppColors.speciesRabbit,
      HealthRecordType.feedingNote => AppColors.speciesBird,
      HealthRecordType.other => AppColors.speciesBird,
    };
  }

  Widget _recordTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(AppStrings.get('recordType')),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          onTap: () {
            setState(() {
              _isTypeMenuOpen = !_isTypeMenuOpen;
            });
          },
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(color: AppColors.primary, width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _typeLabel(_selectedType),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  _isTypeMenuOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.darkGreen,
                ),
              ],
            ),
          ),
        ),
        if (_isTypeMenuOpen) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(color: AppColors.fieldBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: HealthRecordType.values.map((type) {
                final isSelected = _selectedType == type;

                return InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      _isTypeMenuOpen = false;
                    });
                  },
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.lightMint : AppColors.white,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusSmall,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: _typeColor(type),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _typeLabel(type),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            size: 19,
                            color: AppColors.darkGreen,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted || pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(AppStrings.get('date')),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: InputDecorator(
            decoration: fieldDecoration(icon: Icons.calendar_today_outlined),
            child: Text(
              formatDate(_selectedDate),
              style: AppTextStyles.bodyLarge.copyWith(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickPhoto() async {
    if (_isPickingPhoto) return;

    setState(() {
      _isPickingPhoto = true;
    });

    try {
      final photo = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (photo == null) return;

      final extension = photo.name.split('.').last.toLowerCase();

      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        _showMessage(AppStrings.get('invalidImageFormat'));
        return;
      }

      final imageSize = await photo.length();

      if (imageSize > _maxImageBytes) {
        _showMessage(AppStrings.get('imageTooLarge'));
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedPhoto = photo;
      });
    } catch (_) {
      _showMessage(AppStrings.get('photoSelectionFailed'));
    } finally {
      if (mounted) {
        setState(() {
          _isPickingPhoto = false;
        });
      }
    }
  }

  Widget _photoField() {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: AppColors.dashedBorder,
        radius: AppSpacing.radiusMedium,
      ),
      child: Material(
        color: AppColors.lightMint.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: InkWell(
          onTap: _isPickingPhoto ? null : _pickPhoto,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: _selectedPhoto == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 28,
                        color: AppColors.darkGreen,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isPickingPhoto
                                ? AppStrings.get('openingGallery')
                                : AppStrings.get('addAPhoto'),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppStrings.get('photoLimits'),
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                        child: Image.file(
                          File(_selectedPhoto!.path),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _selectedPhoto!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          IconButton(
                            tooltip: AppStrings.get('removePhoto'),
                            onPressed: () {
                              setState(() {
                                _selectedPhoto = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _saveRecord() {
    if (!_formKey.currentState!.validate()) return;

    final enteredTitle = _titleController.text.trim();
    final enteredNotes = _notesController.text.trim();
    final existingRecord = widget.record;

    final originalDisplayedTitle = existingRecord == null
        ? null
        : SampleLocalization.text(
            id: existingRecord.id,
            field: 'title',
            value: existingRecord.title,
          );

    final originalDisplayedNotes =
        existingRecord == null || existingRecord.notes == null
        ? null
        : SampleLocalization.text(
            id: existingRecord.id,
            field: 'notes',
            value: existingRecord.notes!,
          );

    final titleToSave =
        existingRecord != null && enteredTitle == originalDisplayedTitle
        ? existingRecord.title
        : enteredTitle;

    final notesToSave =
        existingRecord != null && enteredNotes == originalDisplayedNotes
        ? existingRecord.notes
        : enteredNotes.isEmpty
        ? null
        : enteredNotes;

    final updatedRecord = HealthRecord(
      id:
          existingRecord?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      petId: existingRecord?.petId ?? activePet.id,
      type: _selectedType,
      title: titleToSave,
      date: _selectedDate,
      notes: notesToSave,
      attachmentUrl: existingRecord?.attachmentUrl,
    );

    if (existingRecord == null) {
      sampleHealthRecords.add(updatedRecord);
    } else {
      final index = sampleHealthRecords.indexWhere(
        (record) => record.id == existingRecord.id,
      );

      if (index == -1) {
        _showMessage(AppStrings.get('recordNotFound'));
        return;
      }

      sampleHealthRecords[index] = updatedRecord;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkGreen),
        title: Text(
          AppStrings.get('createEditRecord'),
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            _recordTypeField(),
            const SizedBox(height: AppSpacing.lg),
            AppFormField(
              label: AppStrings.get('title'),
              hintText: AppStrings.get('titleHint'),
              controller: _titleController,
              labelAbove: true,
              isRequired: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.get('enterTitle');
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _dateField(),
            const SizedBox(height: AppSpacing.lg),
            AppFormField(
              label: AppStrings.get('notesOptional'),
              hintText: AppStrings.get('notesHint'),
              controller: _notesController,
              labelAbove: true,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            _photoField(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.navBorder)),
        ),
        child: SafeArea(
          top: false,
          child: PrimaryButton(
            text: widget.record == null
                ? AppStrings.get('createRecord')
                : AppStrings.get('saveChanges'),
            onPressed: _saveRecord,
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final end = (distance + 6).clamp(0.0, metric.length);

        canvas.drawPath(metric.extractPath(distance, end), paint);

        distance += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
