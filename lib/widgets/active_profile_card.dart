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
                  petName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  petType,
                  style: Theme.of(context).textTheme.bodyMedium,
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
