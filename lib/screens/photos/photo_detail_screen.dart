
import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/pet_photo.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../l10n/app_strings.dart';
import '../../widgets/confirm_dialog.dart';

class PhotoDetailScreen extends StatelessWidget {
  final PetPhoto photo;
  final int photoNumber;
  final String petName;
  final VoidCallback onDelete;

  const PhotoDetailScreen({
    super.key,
    required this.photo,
    required this.photoNumber,
    required this.petName,
    required this.onDelete,
  });

  Widget _photoImage() {
    final path = photo.imageUrl;

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => _imageFallback(),
      );
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => _imageFallback(),
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return  Center(
      child: Icon(
        Icons.pets,
        size: 48,
        color: AppColors.secondaryText,
      ),
    );
  }
  // Delete confirmation dialog (same style as the other delete dialogs)
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: AppStrings.get('deletePhotoTitle'),
      message: AppStrings.get('deletePhotoMessage'),
      confirmText: AppStrings.get('delete'),
    );

    // Only delete when the user confirms
    if (confirmed) {
      onDelete();
    }
  }

  
    

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Photo
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: _photoImage(),
              ),
            ),

            const SizedBox(height: 18),

            // Photo title
            Text(
              AppStrings.get('photoNumber')
                  .replaceAll('{number}', photoNumber.toString()),
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
              ),
            ),

            const SizedBox(height: 8),

            // Album information
            Text(
              AppStrings.get('addedToAlbum')
                  .replaceAll('{name}', petName),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // Close and Delete buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGreen,
                      backgroundColor: AppColors.white,
                      side:  BorderSide(
                        color: AppColors.fieldBorder,
                      ),
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppStrings.get('close')),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                    ),
                    label: Text(AppStrings.get('deletePhoto')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      backgroundColor: AppColors.white,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.45),
                      ),
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
