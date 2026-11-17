
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

class HealthRecordFormScreen extends StatefulWidget {
  const HealthRecordFormScreen({super.key});

  @override
  State<HealthRecordFormScreen> createState() =>
      _HealthRecordFormScreenState();
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
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _typeLabel(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.vaccination => 'Vaccination',
      HealthRecordType.vetVisit => 'Vet visit',
      HealthRecordType.checkUp => 'Check-up',
      HealthRecordType.medication => 'Medication',
      HealthRecordType.parasiteTreatment => 'Parasite treatment',
      HealthRecordType.feedingNote => 'Feeding note',
      HealthRecordType.other => 'Other',
    };
  }

  Color _typeColor(HealthRecordType type) {
    return switch (type) {
      HealthRecordType.vaccination => AppColors.primary,
      HealthRecordType.vetVisit => AppColors.peach,
      HealthRecordType.checkUp => AppColors.speciesHamster,
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
        fieldLabel('Record Type'),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusMedium,
          ),
          onTap: () {
            setState(() {
              _isTypeMenuOpen = !_isTypeMenuOpen;
            });
          },
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusMedium,
              ),
              border: Border.all(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _typeLabel(_selectedType),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusMedium,
              ),
              border: Border.all(
                color: AppColors.fieldBorder,
              ),
              boxShadow: const [
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
                  borderRadius: BorderRadius.circular(
                    AppSpacing.radiusSmall,
                  ),
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
                      color: isSelected
                          ? AppColors.lightMint
                          : AppColors.white,
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
                          const Icon(
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
        fieldLabel('Date'),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusMedium,
          ),
          child: InputDecorator(
            decoration: fieldDecoration(
              icon: Icons.calendar_today_outlined,
            ),
            child: Text(
              formatDate(_selectedDate),
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _pickPhoto() async {
    if (_isPickingPhoto) return;

    setState(() {
      _isPickingPhoto = true;
    });

    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (photo == null) return;

      final extension = photo.name.split('.').last.toLowerCase();

      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        _showMessage('Please select a JPG or PNG image.');
        return;
      }

      final imageSize = await photo.length();

      if (imageSize > _maxImageBytes) {
        _showMessage('The image must be smaller than 10 MB.');
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedPhoto = photo;
      });
    } catch (_) {
      _showMessage('Could not select the photo. Please try again.');
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
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMedium,
        ),
        child: InkWell(
          onTap: _isPickingPhoto ? null : _pickPhoto,
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusMedium,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: _selectedPhoto == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
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
                                ? 'Opening gallery...'
                                : 'Add a photo',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'JPG or PNG · Up to 10 MB',
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
                            tooltip: 'Remove photo',
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

    final notes = _notesController.text.trim();

    final record = HealthRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      petId: activePet.id,
      type: _selectedType,
      title: _titleController.text.trim(),
      date: _selectedDate,
      notes: notes.isEmpty ? null : notes,
    );

    sampleHealthRecords.add(record);

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
        iconTheme: const IconThemeData(
          color: AppColors.darkGreen,
        ),
        title: Text(
          'Create / edit record',
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w700,
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
              label: 'Title',
              hintText: 'e.g. Combination vaccine',
              controller: _titleController,
              labelAbove: true,
              isRequired: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _dateField(),
            const SizedBox(height: AppSpacing.lg),
            AppFormField(
              label: 'Notes (Optional)',
              hintText: 'Enter record details...',
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
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.navBorder,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: PrimaryButton(
            text: 'Create record',
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

  const _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

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
        final end = (distance + 6).clamp(
          0.0,
          metric.length,
        );

        canvas.drawPath(
          metric.extractPath(distance, end),
          paint,
        );

        distance += 11;
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _DashedBorderPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius;
  }
}
