
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

InputDecoration fieldDecoration({
  String? hint,
  IconData? icon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodyLarge.copyWith(
      color: AppColors.hint,
    ),
    prefixIcon: prefixIcon ??
    (icon == null
        ? null
        : Icon(
            icon,
            color: AppColors.secondaryText,
          )),
    filled: true,
    fillColor: AppColors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 18,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.fieldBorder,
        width: 1.4,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: 1.8,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.danger,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.danger,
        width: 1.8,
      ),
    ),
  );
}

Widget fieldLabel(String label) {
  return RichText(
    text: TextSpan(
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.darkGreen,
      ),
      children: [
        TextSpan(text: label),
        const TextSpan(
          text: ' *',
          style: TextStyle(
            color: AppColors.danger,
          ),
        ),
      ],
    ),
  );
}
