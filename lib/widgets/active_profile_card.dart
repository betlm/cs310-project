import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ActiveProfileCard extends StatelessWidget {
  final String petName;
  final String petType;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ActiveProfileCard({
    super.key,
    required this.petName,
    required this.petType,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightMint,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFB8E3D9),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                backgroundImage: imageUrl != null
                    ? AssetImage(imageUrl!)
                    : null,
                child: imageUrl == null
                    ? const Icon(
                        Icons.pets,
                        color: AppColors.white,
                        size: 28,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active profile',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$petName · $petType',
                      style: AppTextStyles.headingSmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.darkGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
