
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        title: Text(
          'Support Kurtaran Ev',
          style: AppTextStyles.headingSmall,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.volunteer_activism_outlined,
                size: 56,
                color: AppColors.primary,
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                'Every little act of kindness matters',
                textAlign: TextAlign.center,
                style: AppTextStyles.headingSmall,
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Donation options will be available here soon.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
