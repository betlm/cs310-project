import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/pet_photo.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

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
    return const Center(
      child: Icon(Icons.pets, size: 48, color: AppColors.secondaryText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(aspectRatio: 1.2, child: _photoImage()),
            ),
            const SizedBox(height: 18),
            Text(
              'Photo $photoNumber',
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Added to $petName's album",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGreen,
                      backgroundColor: AppColors.white,
                      side: const BorderSide(color: AppColors.fieldBorder),
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('Delete photo'),
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
