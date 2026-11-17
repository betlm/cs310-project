import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/pet.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/species_colors.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/primary_button.dart';

/// Create edit pet form
/// Opened empty to add a new pet, or with a pet as the route argument to edit that pet
class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  // Photo
  final _imagePicker = ImagePicker(); //galeriyi acar
  static const int _maxImageBytes = 10 * 1024 * 1024; // 10 MB
  XFile? _selectedPhoto;
  bool _isPickingPhoto = false;

  // Name and species
  final _nameController = TextEditingController();
  PetSpecies _selectedSpecies = PetSpecies.cat;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

    /// Shows a short message at the bottom of the screen.
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

  /// Saves the pet filled  later in the save step
  void _saveProfile() {}
  Widget _label(String text, {bool required = false}) {
    final children = <Widget>[
      Text(
        text,
        style: const TextStyle(
          fontSize: 16,
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
            fontSize: 16,
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
          width: 132,
          height: 132,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardBorder,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.photo_camera_outlined,
                size: 30,
                color: AppColors.secondaryText,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _isPickingPhoto ? 'Opening...' : 'Add photo',
                style: const TextStyle(
                  fontSize: 13,
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
            radius: 66,
            backgroundColor: AppColors.cardBorder,
            backgroundImage: FileImage(File(_selectedPhoto!.path)),
          ),
          // Small red X to remove the photo.
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPhoto = null;
                });
              },
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.white,
                child: Icon(Icons.close, size: 18, color: AppColors.danger),
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
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }


  /// One species card: avatar and name. The selected card is mint
  /// with a green border.
  Widget _speciesCard(PetSpecies species) {
    final isSelected = species == _selectedSpecies;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpecies = species;
        });
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
              radius: 22,
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
            _label('Name', required: true),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 15, color: AppColors.darkGreen),
              decoration: fieldDecoration(hint: 'e.g. Misket').copyWith(
                hintStyle: const TextStyle(fontSize: 15, color: AppColors.hint),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _label('Species', required: true),
            _speciesRow(PetSpecies.cat, PetSpecies.dog, PetSpecies.bird),
            const SizedBox(height: 10),
            _speciesRow(PetSpecies.fish, PetSpecies.rabbit, PetSpecies.hamster),
            const SizedBox(height: AppSpacing.lg),
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