import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ActiveProfileCard extends StatelessWidget {
  final String petName;
  final String petType;
  final String? imageUrl;

  const ActiveProfileCard({
    super.key,
    required this.petName,
    required this.petType,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: const Icon(
              Icons.pets,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 'Active profile',
                 style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                 '$petName · $petType',
                 style: Theme.of(context).textTheme.titleLarge,
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
    );
  }
}
