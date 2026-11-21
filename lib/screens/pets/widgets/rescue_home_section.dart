
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class RescueHomeSection extends StatefulWidget {
  final VoidCallback onAdopt;
  final VoidCallback onDonate;

  const RescueHomeSection({
    super.key,
    required this.onAdopt,
    required this.onDonate,
  });

  @override
  State<RescueHomeSection> createState() =>
      _RescueHomeSectionState();
}

class _RescueHomeSectionState extends State<RescueHomeSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.lightMint,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLarge,
        ),
        border: Border.all(color: AppColors.mintBorder),
      ),
      child: Column(
        children: [
          // Tap to expand or collapse
          InkWell(
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusLarge,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
                ),
              child: Row(
                children: [
                  // Kurtaran Ev logo
                  Image.asset(
                    'assets/images/kurtaran_ev_logo.png',
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.pets_outlined,
                        size: 40,
                        color: AppColors.primary,
                      );
                    },
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  Expanded(
                    child: Text(
                      'Looking for a new friend?',
                      style: AppTextStyles.headingSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.darkGreen,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content shown when expanded
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Adopt a pet or support shelter '
                          'animals at Kurtaran Ev.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        Row(
                          children: [
                            Expanded(
                              child: _RescueActionButton(
                                label: 'Adopt',
                                icon: Icons.pets_outlined,
                                isPrimary: true,
                                onPressed: widget.onAdopt,
                              ),
                            ),

                            const SizedBox(width: AppSpacing.sm),

                            Expanded(
                              child: _RescueActionButton(
                                label: 'Donate',
                                icon: Icons.volunteer_activism_outlined,
                                isPrimary: false,
                                onPressed: widget.onDonate,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _RescueActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _RescueActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isPrimary
        ? AppColors.ink
        : AppColors.darkGreen;

    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: textColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppColors.primary
              : AppColors.white,
          foregroundColor: textColor,
          side: BorderSide(
            color: isPrimary
                ? AppColors.primary
                : AppColors.mintBorder,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusMedium,
            ),
          ),
        ),
      ),
    );
  }
}
