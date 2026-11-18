import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// small white square button 
/// used for the edit and delete buttons on list cards
class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  final double size;

  const SquareIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(size/4),
          border: Border.all(color: AppColors.cardBorder, width: 1.5),
        ),
        child: Icon(icon, color: color, size: size/2),
      ),
    );
  }
}