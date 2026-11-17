import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/sample_data.dart';
import '../../models/weight_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/date_format.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/primary_button.dart';

class WeightEntryFormSheet extends StatefulWidget {
  final String petId;
  final WeightEntry? entry;

  const WeightEntryFormSheet({super.key, required this.petId, this.entry});

  @override
  State<WeightEntryFormSheet> createState() => _WeightEntryFormSheetState();
}

class _WeightEntryFormSheetState extends State<WeightEntryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();

  late DateTime _selectedDate;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.entry?.date ?? DateTime.now();

    if (widget.entry != null) {
      _weightController.text = widget.entry!.weightKg.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _saveWeight() {
    if (!_formKey.currentState!.validate()) return;

    final value = double.tryParse(
      _weightController.text.trim().replaceAll(',', '.'),
    );

    if (value == null || !value.isFinite || value <= 0) {
      return;
    }

    final existingEntry = widget.entry;

    final savedEntry = WeightEntry(
      id: existingEntry?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      petId: widget.petId,
      weightKg: value,
      date: _selectedDate,
    );

    if (existingEntry == null) {
      sampleWeightEntries.add(savedEntry);
    } else {
      final index = sampleWeightEntries.indexWhere(
        (entry) => entry.id == existingEntry.id,
      );

      if (index == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Weight entry not found.')),
        );
        return;
      }

      sampleWeightEntries[index] = savedEntry;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.fieldBorder,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'WEIGHT TRACKING',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isEditing ? 'Edit Weight Entry' : 'Add Weight Entry',
                          style: AppTextStyles.headingMedium.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.lightMint,
                          foregroundColor: AppColors.darkGreen,
                        ),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Weight field
                  fieldLabel('Weight (kg)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    style: AppTextStyles.bodyLarge,
                    decoration: fieldDecoration(hint: '4.8').copyWith(
                      suffixText: 'kg',
                      suffixStyle: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a weight';
                      }

                      final number = double.tryParse(
                        value.trim().replaceAll(',', '.'),
                      );

                      if (number == null || !number.isFinite || number <= 0) {
                        return 'Enter a valid weight greater than 0';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 22),

                  // Date field
                  fieldLabel('Date'),
                  const SizedBox(height: 8),
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
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.darkGreen,
                              backgroundColor: AppColors.white,
                              side: const BorderSide(
                                color: AppColors.fieldBorder,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMedium,
                                ),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.darkGreen,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: PrimaryButton(
                          text: _isEditing ? 'Save Changes' : 'Save Weight',
                          onPressed: _saveWeight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
