
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_state.dart';
import '../../data/sample_data.dart';
import '../../models/pet.dart';
import '../../models/pet_photo.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/active_pet_bar.dart';
import '../home/widgets/pet_chips_row.dart';
import 'photo_detail_screen.dart';
import 'photo_selection.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final ImagePicker _picker = ImagePicker();

  bool _isSelectionMode = false;

  List<PetPhoto> get _photos => photosFor(activePet.id);

  void _startSelection() {
    if (_photos.isEmpty) return;

    setState(() {
      _isSelectionMode = true;
    });
  }

  void _cancelSelection() {
    setState(() {
      _isSelectionMode = false;
    });
  }

  Future<void> _selectPet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select a pet',
                  style: AppTextStyles.headingSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose whose album to view',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 20),
                PetChipsRow(
                  selectedPet: activePet,
                  onPetSelected: (Pet pet) {
                    setState(() {
                      activePet = pet;
                      _isSelectionMode = false;
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

  Future<void> _addPhoto(ImageSource source) async {
    final petId = activePet.id;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null || !mounted) return;

      setState(() {
        samplePhotos.add(
          PetPhoto(
            id: 'photo-${DateTime.now().microsecondsSinceEpoch}',
            petId: petId,
            imageUrl: image.path,
            addedAt: DateTime.now(),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo added successfully!'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add photo: $error'),
        ),
      );
    }
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.lightMint,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.secondaryText,
          size: 32,
        ),
      ),
    );
  }

  Widget _photoImage(PetPhoto photo) {
    final path = photo.imageUrl;

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _imageFallback();
        },
      );
    }

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _imageFallback();
        },
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _imageFallback();
      },
    );
  }

  // Single photo deletion.
  // The confirmation is handled by PhotoDetailScreen.
  void _deletePhoto(
    PetPhoto photo,
    BuildContext dialogContext,
  ) {
    setState(() {
      samplePhotos.removeWhere(
        (item) =>
            item.id == photo.id &&
            item.petId == photo.petId,
      );
    });

    if (dialogContext.mounted) {
      Navigator.pop(dialogContext);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo deleted.'),
        ),
      );
    }
  }

  Future<void> _openPhoto(PetPhoto photo) async {
    final photoNumber = _photos.indexOf(photo) + 1;
    final petName = activePet.name;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return PhotoDetailScreen(
          photo: photo,
          photoNumber: photoNumber,
          petName: petName,
          onDelete: () {
            _deletePhoto(photo, dialogContext);
          },
        );
      },
    );
  }

  // Delete only selected photos from the current pet's album.
  void _deleteSelectedPhotos(Set<String> selectedIds) {
    if (selectedIds.isEmpty) return;

    final petId = activePet.id;
    final count = selectedIds.length;

    setState(() {
      samplePhotos.removeWhere(
        (photo) =>
            photo.petId == petId &&
            selectedIds.contains(photo.id),
      );

      _isSelectionMode = false;
    });

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.lightMint,
        elevation: 2,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.fieldBorder,
          ),
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.darkGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$count ${count == 1 ? 'photo' : 'photos'} deleted successfully!',
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _albumHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${activePet.name}'s album",
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${_photos.length} photos',
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),

        if (_isSelectionMode)
          TextButton(
            onPressed: _cancelSelection,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
              ),
            ),
          )
        else
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: AppColors.darkGreen,
            ),
            color: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              if (value == 'select') {
                _startSelection();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'select',
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.darkGreen,
                      size: 21,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Select Photos',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _photoGrid() {
    final photos = _photos;

    if (photos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 56,
              color: AppColors.secondaryText,
            ),
            const SizedBox(height: 14),
            Text(
              'No photos yet',
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first photo using Camera or Gallery.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 14) / 3;

        return Wrap(
          spacing: 7,
          runSpacing: 7,
          children: photos.map((photo) {
            return SizedBox(
              width: itemWidth,
              height: itemWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Material(
                  color: AppColors.lightMint,
                  child: InkWell(
                    onTap: () => _openPhoto(photo),
                    child: _photoImage(photo),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _bottomButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 25),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
          backgroundColor: AppColors.white,
          side: const BorderSide(
            color: AppColors.fieldBorder,
            width: 1.5,
          ),
          minimumSize: const Size(0, 62),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.cardBorder,
          ),
        ),
        title: const Text(
          'Photos',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                24,
              ),
              children: [
                ActivePetBar(
                  pet: activePet,
                  onTap: _selectPet,
                ),
                const SizedBox(height: 24),
                _albumHeader(),
                const SizedBox(height: 20),

                // Show selection UI or regular photo grid.
                if (_isSelectionMode)
                  PhotoSelection(
                    key: ValueKey(activePet.id),
                    photos: _photos,
                    imageBuilder: _photoImage,
                    onDelete: _deleteSelectedPhotos,
                    onCancel: _cancelSelection,
                  )
                else
                  _photoGrid(),
              ],
            ),
          ),

          // Camera and Gallery remain available
          // outside selection mode.
          if (!_isSelectionMode)
            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                16,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(
                    color: AppColors.fieldBorder,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _bottomButton(
                      label: 'Camera',
                      icon: Icons.camera_alt_outlined,
                      onPressed: () {
                        _addPhoto(ImageSource.camera);
                      },
                    ),
                    const SizedBox(width: 12),
                    _bottomButton(
                      label: 'Gallery',
                      icon: Icons.image_outlined,
                      onPressed: () {
                        _addPhoto(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
