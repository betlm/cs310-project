import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class WelcomePreferences extends StatelessWidget {
  const WelcomePreferences({
    super.key,
    required this.language,
    required this.isDark,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  final String language;
  final bool isDark;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final isTurkish = language == 'tr';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: isTurkish ? 'İngilizceye geç' : 'Switch to Turkish',
          child: TextButton.icon(
            onPressed: () => onLanguageChanged(isTurkish ? 'en' : 'tr'),
            icon: const Icon(Icons.language, size: 16),
            label: Text(isTurkish ? 'EN' : 'TR'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.darkGreen,
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              textStyle: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => onThemeChanged(!isDark),
          tooltip: AppStrings.get(isDark ? 'light' : 'dark'),
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 20,
            color: AppColors.darkGreen,
          ),
        ),
      ],
    );
  }
}