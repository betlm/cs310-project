import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../l10n/app_strings.dart';
import '../../models/pet.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/species_colors.dart';
import '../../utils/date_format.dart';
import '../../utils/pet_format.dart';
import '../../utils/sample_localization.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/primary_button.dart';

/// Create / edit pet form.
class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();

  Pet? _editingPet;
  bool _formInitialized = false;

  final _imagePicker = ImagePicker();
  static const int _maxImageBytes = 10 * 1024 * 1024;

  XFile? _selectedPhoto;
  bool _isPickingPhoto = false;

  final _nameController = TextEditingController();
  PetSpecies _selectedSpecies = PetSpecies.cat;

  final _breedController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _ageController = TextEditingController();

  bool _useBirthDate = true;
  DateTime? _birthDate;

  PetSex _selectedSex = PetSex.unknown;

  final _weightController = TextEditingController();
  final _microchipController = TextEditingController();
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _birthDateController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _microchipController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formInitialized) return;
    _formInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is! Pet) return;

    final pet = arguments;
    _editingPet = pet;

    _nameController.text = pet.name;
    _selectedSpecies = pet.species;

    _breedController.text = pet.breed == null
        ? ''
        : SampleLocalization.text(
            id: pet.id,
            field: 'breed',
            value: pet.breed!,
          );

    _selectedSex = pet.sex;
    _microchipController.text = pet.microchipNumber ?? '';
    _tagController.text = pet.tagInfo ?? '';

    if (pet.weightKg != null) {
      _weightController.text = pet.weightKg.toString();
    }

    if (pet.birthDate != null) {
      _useBirthDate = true;
      _birthDate = pet.birthDate;
      _birthDateController.text = formatDate(pet.birthDate!);
    } else if (pet.approximateAgeYears != null) {
      _useBirthDate = false;
      _ageController.text = pet.approximateAgeYears.toString();
    }
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

      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        _showMessage(AppStrings.get('invalidImageFormat'));
        return;
      }

      final size = await photo.length();

      if (size > _maxImageBytes) {
        _showMessage(AppStrings.get('imageTooLarge'));
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedPhoto = photo;
      });
    } catch (e) {
      _showMessage(AppStrings.get('photoSelectionFailed'));
    } finally {
      if (mounted) {
        setState(() {
          _isPickingPhoto = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      _showMessage(AppStrings.get('fixFields'));
      return;
    }

    final breed = _breedController.text.trim();
    final existingPet = _editingPet;

    final originalDisplayedBreed =
        existingPet == null || existingPet.breed == null
        ? null
        : SampleLocalization.text(
            id: existingPet.id,
            field: 'breed',
            value: existingPet.breed!,
          );

    final String? breedToSave;

    if (existingPet != null && breed == originalDisplayedBreed) {
      breedToSave = existingPet.breed;
    } else {
      breedToSave = breed.isEmpty ? null : breed;
    }

    final microchip = _microchipController.text.trim();
    final tag = _tagController.text.trim();

    final weightText = _weightController.text.trim().replaceAll(',', '.');

    final ageText = _ageController.text.trim();

    double? weight;

    if (weightText.isNotEmpty) {
      weight = double.parse(weightText);
    }

    DateTime? birthDate;
    int? approximateAge;

    if (_useBirthDate) {
      birthDate = _birthDate;
    } else if (ageText.isNotEmpty) {
      approximateAge = int.parse(ageText);
    }

    final pet = Pet(
      id: _editingPet?.id ?? 'pet-${DateTime.now().microsecondsSinceEpoch}',
      avatarAsset: _editingPet?.avatarAsset,
      name: _nameController.text.trim(),
      species: _selectedSpecies,
      breed: breedToSave,
      birthDate: birthDate,
      approximateAgeYears: approximateAge,
      sex: _selectedSex,
      weightKg: weight,
      microchipNumber: microchip.isEmpty ? null : microchip,
      tagInfo: tag.isEmpty ? null : tag,
    );

    if (_editingPet == null) {
      samplePets.add(pet);
    } else {
      final index = samplePets.indexWhere((p) => p.id == pet.id);

      if (index == -1) {
        _showMessage(AppStrings.get('petNotFound'));
        return;
      }

      samplePets[index] = pet;

      if (activePet.id == pet.id) {
        activePet = pet;
      }
    }

    await showConfirmDialog(
      context: context,
      title: AppStrings.get('petSaved'),
      message: AppStrings.get('petSavedMessage').replaceAll('{name}', pet.name),
      confirmText: AppStrings.get('ok'),
      cancelText: null,
      isDanger: false,
      icon: Icons.check_circle_outline,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Widget _label(String text, {bool required = false}) {
    final children = <Widget>[
      Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.darkGreen,
        ),
      ),
    ];

    if (required) {
      children.add(
        const Text(
          ' *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.danger,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(children: children),
    );
  }

  Widget _photoPicker() {
    Widget circle;

    if (_selectedPhoto == null) {
      circle = CustomPaint(
        foregroundPainter: _DashedCirclePainter(color: AppColors.dashedBorder),
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardBorder,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                size: 22,
                color: AppColors.secondaryText,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _isPickingPhoto
                    ? AppStrings.get('opening')
                    : AppStrings.get('addPhoto'),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      circle = Stack(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.cardBorder,
            backgroundImage: FileImage(File(_selectedPhoto!.path)),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPhoto = null;
                });
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.white,
                child: Icon(Icons.close, size: 14, color: AppColors.danger),
              ),
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        children: [
          GestureDetector(onTap: _pickPhoto, child: circle),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.get('optional'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _speciesCard(PetSpecies species) {
    final isSelected = species == _selectedSpecies;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpecies = species;
        });
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightMint : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: speciesColor(species),
              backgroundImage: AssetImage(
                'assets/images/default-${species.name}.png',
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  localizedSpeciesLabel(species),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _speciesRow(PetSpecies a, PetSpecies b, PetSpecies c) {
    return Row(
      children: [
        Expanded(child: _speciesCard(a)),
        const SizedBox(width: 10),
        Expanded(child: _speciesCard(b)),
        const SizedBox(width: 10),
        Expanded(child: _speciesCard(c)),
      ],
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    IconData? icon,
    String? suffix,
  }) {
    return fieldDecoration(hint: hint, icon: icon).copyWith(
      hintStyle: TextStyle(fontSize: 15, color: AppColors.hint),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixText: suffix,
      suffixStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.secondaryText,
      ),
    );
  }

  Widget _ageTab(
    String text, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.darkGreen : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _birthDate = picked;
      _birthDateController.text = formatDate(picked);
    });
  }

  Widget _sexButton(String text, PetSex sex) {
    final isSelected = sex == _selectedSex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSex = sex;
          });
        },
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightMint : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.darkGreen : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }

  void _changeWeight(double change) {
    final text = _weightController.text.trim().replaceAll(',', '.');

    final current = double.tryParse(text) ?? 0;

    var newWeight = current + change;

    if (newWeight < 0) {
      newWeight = 0;
    }

    _weightController.text = newWeight.toStringAsFixed(1);
  }

  Widget _weightStepper() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBorder,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _changeWeight(0.1),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: AppColors.darkGreen,
                  ),
                ),
                GestureDetector(
                  onTap: () => _changeWeight(-0.1),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.darkGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'kg',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return AppStrings.get('petEnterName');
    }

    if (name.length > 30) {
      return AppStrings.get('petNameTooLong');
    }

    return null;
  }

  String? _validateWeight(String? value) {
    final text = value?.trim().replaceAll(',', '.') ?? '';

    if (text.isEmpty) return null;

    final weight = double.tryParse(text);

    if (weight == null) {
      return AppStrings.get('petInvalidWeight');
    }

    if (weight <= 0) {
      return AppStrings.get('petWeightPositive');
    }

    if (weight > 200) {
      return AppStrings.get('petRealisticWeight');
    }

    return null;
  }

  String? _validateAge(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    final age = int.tryParse(text);

    if (age == null || age < 0) {
      return AppStrings.get('petInvalidAge');
    }

    if (age > 40) {
      return AppStrings.get('petRealisticAge');
    }

    return null;
  }

  String? _validateMicrochip(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
      return AppStrings.get('petDigitsOnly');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        title: Text(
          AppStrings.get('createEditPet'),
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md + AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.md + AppSpacing.xs,
            AppSpacing.lg,
          ),
          children: [
            _photoPicker(),
            const SizedBox(height: AppSpacing.lg),

            // Name
            _label(AppStrings.get('petFormName'), required: true),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
              validator: _validateName,
              decoration: _inputDecoration(AppStrings.get('petNameHint')),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Species
            _label(AppStrings.get('petFormSpecies'), required: true),
            _speciesRow(PetSpecies.cat, PetSpecies.dog, PetSpecies.bird),
            const SizedBox(height: 8),
            _speciesRow(PetSpecies.fish, PetSpecies.rabbit, PetSpecies.hamster),
            const SizedBox(height: AppSpacing.lg),

            // Breed
            _label(AppStrings.get('petFormBreed')),
            TextFormField(
              controller: _breedController,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
              decoration: _inputDecoration(AppStrings.get('petBreedHint')),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Age information
            _label(AppStrings.get('petFormAgeInformation')),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _ageTab(
                    AppStrings.get('dateOfBirth'),
                    selected: _useBirthDate,
                    onTap: () {
                      setState(() {
                        _useBirthDate = true;
                      });
                    },
                  ),
                  _ageTab(
                    AppStrings.get('approximateAge'),
                    selected: !_useBirthDate,
                    onTap: () {
                      setState(() {
                        _useBirthDate = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            if (_useBirthDate) ...[
              _label(AppStrings.get('petFormBirthDate')),
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                onTap: _pickBirthDate,
                style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
                decoration: _inputDecoration(
                  appLanguage == 'tr' ? 'GG.AA.YYYY' : 'MM/DD/YYYY',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ] else ...[
              _label(AppStrings.get('petFormApproximateAge')),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
                validator: _validateAge,
                decoration: _inputDecoration(
                  AppStrings.get('petAgeHint'),
                  suffix: AppStrings.get('years'),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            // Sex
            _label(AppStrings.get('petFormSex')),
            Row(
              children: [
                _sexButton(AppStrings.get('male'), PetSex.male),
                const SizedBox(width: 8),
                _sexButton(AppStrings.get('female'), PetSex.female),
                const SizedBox(width: 8),
                _sexButton(AppStrings.get('unknown'), PetSex.unknown),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Weight
            _label(AppStrings.get('petFormWeight')),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
              validator: _validateWeight,
              decoration: _inputDecoration('4.8')
                  .copyWith(suffixIcon: _weightStepper()),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Microchip
            _label(AppStrings.get('petFormMicrochip')),
            TextFormField(
              controller: _microchipController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
              validator: _validateMicrochip,
              decoration: _inputDecoration(AppStrings.get('petMicrochipHint')),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Tag
            _label(AppStrings.get('petFormTag')),
            TextFormField(
              controller: _tagController,
              style: TextStyle(fontSize: 15, color: AppColors.darkGreen),
              decoration: _inputDecoration(AppStrings.get('petTagHint')),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md + AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.md + AppSpacing.xs,
              AppSpacing.md,
            ),
            child: PrimaryButton(
              text: AppStrings.get('saveProfile'),
              onPressed: _saveProfile,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dashed circle around the photo picker.
class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashCount = 40;
    const strokeWidth = 1.5;
    const dashFraction = 0.6;
    const slot = 2 * math.pi / dashCount;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(rect, i * slot, slot * dashFraction, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
