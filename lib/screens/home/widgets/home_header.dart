import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// Logo, app name and subtitle shown at the top of Home.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Image.asset('assets/images/logo.png', width: 56, height: 56),
        const SizedBox(width: AppSpacing.md),
        // Expanded lets the texts wrap instead of overflowing
        // on narrow screens.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PetPocket', style: textTheme.headlineLarge),
              Text('Pet Care & Tracking App', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}