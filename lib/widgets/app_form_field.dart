
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  // Optional features for Figma-style forms.
  final bool labelAbove;
  final bool isRequired;
  final int maxLines;

  const AppFormField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.labelAbove = false,
    this.isRequired = false,
    this.maxLines = 1,
  }) : assert(
          !obscureText || maxLines == 1,
          'Obscured fields must have maxLines = 1.',
        );

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: AppTextStyles.bodyLarge.copyWith(
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: labelAbove ? null : label,
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.hint,
        ),
        filled: labelAbove,
        fillColor: AppColors.white,
        contentPadding: labelAbove
            ? const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusMedium,
          ),
        ),
        enabledBorder: labelAbove
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusMedium,
                ),
                borderSide:  BorderSide(
                  color: AppColors.fieldBorder,
                ),
              )
            : null,
        focusedBorder: labelAbove
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusMedium,
                ),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              )
            : null,
      ),
    );

    if (!labelAbove) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
                        children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.danger,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        field,
      ],
    );
  }
}
