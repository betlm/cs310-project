import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/app_state.dart';
import '../../models/pet.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/species_colors.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/primary_button.dart';
import '../../utils/date_format.dart';
import '../../data/sample_data.dart';

/// Create edit pet form
/// Opened empty to add a new pet, or with a pet as the route argument to edit that pet
class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  /// The pet being edited or not
  Pet? _editingPet;
  ///the fields are filled only once
  bool _formInitialized = false;
  // Photo
  final _imagePicker = ImagePicker(); //galeriyi acar
  static const int _maxImageBytes = 10 * 1024 * 1024; // 10 MB
  XFile? _selectedPhoto;
  bool _isPickingPhoto = false;

  // Name and species
  final _nameController = TextEditingController();
  PetSpecies _selectedSpecies = PetSpecies.cat;

  // Breed and age
  final _breedController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _ageController = TextEditingController();
  bool _useBirthDate = true; // true: Date of Birth tab, false: Approximate Age
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
  /// Reads the pet sent with the route from edit buton
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formInitialized) return;
    _formInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is! Pet) return; // no pet: creating a new one

    final pet = arguments;
    _editingPet = pet;

    _nameController.text = pet.name;
    _selectedSpecies = pet.species;
    _breedController.text = pet.breed ?? '';
    _selectedSex = pet.sex;
    _microchipController.text = pet.microchipNumber ?? '';
    _tagController.text = pet.tagInfo ?? '';

    if (pet.weightKg != null) {
      _weightController.text = pet.weightKg.toString();
    }

    // Open the tab that matches the saved age info
    if (pet.birthDate != null) {
      _useBirthDate = true;
      _birthDate = pet.birthDate;
      _birthDateController.text = formatDate(pet.birthDate!);
    } else if (pet.approximateAgeYears != null) {
      _useBirthDate = false;
      _ageController.text = pet.approximateAgeYears.toString();
    }
  }

    /// Shows a short message at the bottom of the screen
  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// open the gallery and keeps photo if it is a JPG or PNG smaller than 10 MB
  Future<void> _pickPhoto() async {
    if (_isPickingPhoto) return;

    setState(() {
      _isPickingPhoto = true;
    });

    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      // The user closed the gallery without choosing a photo
      if (photo == null) return;
      // Only JPG and PNG files are allowed
      final extension = photo.name.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        _showMessage('Please select a JPG or PNG image.');
        return;
      }
      // The photo must be smaller than 10 MB
      final size = await photo.length();
      if (size > _maxImageBytes) {
        _showMessage('The image must be smaller than 10 MB.');
        return;
      }

      if (!mounted) return;
      setState(() {
        _selectedPhoto = photo;
      });
    } catch (e) {
      _showMessage('Could not select the photo. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingPhoto = false;
        });
      }
    }
  }

  /// Check form - adds the new pet to the list shows "Pet Saved" and closes the form
  Future<void> _saveProfile() async {
    // Runs every validator shows the red messages if something is wrong
    if (!_formKey.currentState!.validate()) {
      _showMessage('Please fix the highlighted fields.');
      return;
    }

    // optional one - if empty = null
    final breed = _breedController.text.trim();
    final microchip = _microchipController.text.trim();
    final tag = _tagController.text.trim();
    final weightText = _weightController.text.trim().replaceAll(',', '.');
    final ageText = _ageController.text.trim();

    double? weight;
    if (weightText.isNotEmpty) {
      weight = double.parse(weightText);
    }

    // age selected
    DateTime? birthDate;
    int? approximateAge;
    if (_useBirthDate) {
      birthDate = _birthDate;
    } else if (ageText.isNotEmpty) {
      approximateAge = int.parse(ageText);
    }

    final pet = Pet(
      id: _editingPet?.id ?? 'pet-${DateTime.now().microsecondsSinceEpoch}',
      avatarAsset: _editingPet?.avatarAsset, ///Keep the same id when editing; create a new  for a new pet
      name: _nameController.text.trim(),
      species: _selectedSpecies,
      breed: breed.isEmpty ? null : breed,
      birthDate: birthDate,
      approximateAgeYears: approximateAge,
      sex: _selectedSex,
      weightKg: weight,
      microchipNumber: microchip.isEmpty ? null : microchip,
      tagInfo: tag.isEmpty ? null : tag,
    );

      if (_editingPet == null) {
      // New pet- add it to the list
      samplePets.add(pet);
    } else {
      // Edited pet- replace the old one in the list
      final index = samplePets.indexWhere((p) => p.id == pet.id);
      if (index == -1) {
        _showMessage('This pet could not be found.');
        return;
      }
      samplePets[index] = pet;

      // Home shows activePet, so update it 
      if (activePet.id == pet.id) {
        activePet = pet;
      }
    }

    // Green "Pet Saved" dialog with one OK button
    await showConfirmDialog(
      context: context,
      title: 'Pet Saved',
      message: '${pet.name} was saved successfully.',
      confirmText: 'OK',
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
        style: const TextStyle(
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


  /// Round dashed photo picker at the top of the form.
  /// Shows the chosen photo, or a camera icon if there is none.
  Widget _photoPicker() {
    Widget circle;

    if (_selectedPhoto == null) {
      circle = CustomPaint(
        foregroundPainter: _DashedCirclePainter(
          color: AppColors.dashedBorder,
        ),
        child: Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardBorder,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.photo_camera_outlined,
                size: 22,
                color: AppColors.secondaryText,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _isPickingPhoto ? 'Opening...' : 'Add photo',
                style: const TextStyle(
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
          // red X button
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPhoto = null;
                });
              },
              child: const CircleAvatar(
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
          GestureDetector(
            onTap: _pickPhoto,
            child: circle,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Optional',
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


  /// One species card: avatar and name- border:green
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
              backgroundImage:
                  AssetImage('assets/images/default-${species.name}.png'),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  speciesLabel(species),
                  style: const TextStyle(
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

  /// Three species cards side by side.
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
  /// icon is shown on the left suffix like kg on the right
  InputDecoration _inputDecoration(
    String hint, {
    IconData? icon,
    String? suffix,
  }) {
    return fieldDecoration(hint: hint, icon: icon).copyWith(
      hintStyle: const TextStyle(fontSize: 15, color: AppColors.hint),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      suffixText: suffix,
      suffixStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.secondaryText,
      ),
    );
  }

  /// One side of the "Date of Birth / Approximate Age" switch
  Widget _ageTab(String text, {required bool selected, required VoidCallback onTap}) {
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
                ? const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 6,
                      offset: Offset(0, 2),
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

  /// Opens the date picker and shows the chosen date 
  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(), // a pet cannot be born in the future
    );

    if (picked == null || !mounted) return;

    setState(() {
      _birthDate = picked;
      _birthDateController.text = formatDate(picked);
    });
  }
  /// male female unknown buttons
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

  /// küçük arttır azalt butonu sağ kenar
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
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: AppColors.darkGreen,
                  ),
                ),
                GestureDetector(
                  onTap: () => _changeWeight(-0.1),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.darkGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Text(
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

  // validators part

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Please enter a name';
    }
    if (name.length > 30) {
      return 'Name must be at most 30 characters';
    }
    return null;
  }

  String? _validateWeight(String? value) {
    final text = value?.trim().replaceAll(',', '.') ?? '';
    if (text.isEmpty) return null; // optional

    final weight = double.tryParse(text);
    if (weight == null) {
      return 'Enter a number like 4.8';
    }
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    if (weight > 200) {
      return 'Please enter a realistic weight';
    }
    return null;
  }

  String? _validateAge(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null; // optional

    final age = int.tryParse(text);
    if (age == null || age < 0) {
      return 'Enter a whole number like 3';
    }
    if (age > 40) {
      return 'Please enter a realistic age';
    }
    return null;
  }

  String? _validateMicrochip(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null; // optional

    if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
      return 'Use digits only';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text(
          'Create / edit pet',
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
            AppSpacing.md + AppSpacing.xs, // 20
            AppSpacing.lg,
            AppSpacing.md + AppSpacing.xs,
            AppSpacing.lg,
          ),
          children: [
            _photoPicker(),
            const SizedBox(height: AppSpacing.lg),

            // Name
            _label('Name', required: true),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
              validator: _validateName,
              decoration: _inputDecoration('e.g. Misket'),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Species
            _label('Species', required: true),
            _speciesRow(PetSpecies.cat, PetSpecies.dog, PetSpecies.bird),
            const SizedBox(height: 8),
            _speciesRow(PetSpecies.fish, PetSpecies.rabbit, PetSpecies.hamster),
            const SizedBox(height: AppSpacing.lg),

            // Breed
            _label('Breed (Optional)'),
            TextFormField(
              controller: _breedController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
              decoration: _inputDecoration('e.g. Tabby'),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Age: birth date or approximate age
            _label('Age information · Optional'),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.lightMint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _ageTab(
                    'Date of Birth',
                    selected: _useBirthDate,
                    onTap: () {
                      setState(() {
                        _useBirthDate = true;
                      });
                    },
                  ),
                  _ageTab(
                    'Approximate Age',
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

            // Only the field of the selected tab is shown.
            if (_useBirthDate) ...[
              _label('Date of Birth (Optional)'),
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                onTap: _pickBirthDate,
                style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
                decoration: _inputDecoration(
                  'DD/MM/YYYY',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ] else ...[
              _label('Approximate Age (Optional)'),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
                validator: _validateAge,
                decoration: _inputDecoration('e.g. 3', suffix: 'years'),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),

            // Sex
            _label('Sex · Optional'),
            Row(
              children: [
                _sexButton('Male', PetSex.male),
                const SizedBox(width: 8),
                _sexButton('Female', PetSex.female),
                const SizedBox(width: 8),
                _sexButton('Unknown', PetSex.unknown),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Weight
            _label('Weight (Optional)'),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
              validator: _validateWeight,
              decoration: _inputDecoration('4.8').copyWith(
                suffixIcon: _weightStepper(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Microchip
            _label('Microchip Number (Optional)'),
            TextFormField(
              controller: _microchipController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
              validator: _validateMicrochip,
              decoration: _inputDecoration('Number'),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Tag
            _label('Tag Information (Optional)'),
            TextFormField(
              controller: _tagController,
              style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
              decoration: _inputDecoration('Tag ID or identifying details'),
            ),
          ],
        ),
      ),
      // White strip at the bottom with the Save button
      // It stays visible while the form scrolls
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
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
              text: 'Save profile',
              onPressed: _saveProfile,
            ),
          ),
        ),
      ),
    );
  }
}


///
///dashline func
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