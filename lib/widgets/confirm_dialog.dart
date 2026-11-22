import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../l10n/app_strings.dart';

/// Shows a dialog with an icon, a title, a message and one or two buttons
/// returns true if the user pressed the confirm button or false otherwise

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  String? cancelText,
  bool isDanger = true,
  IconData icon = Icons.delete_outline,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText ?? AppStrings.get('cancel'),
        isDanger: isDanger,
        icon: icon,
      );
    },
  );

  // result is null if the user taps outside the dialog
  return result == true;
}

///widget side
///
/// The dialog itself - Red style for deleting, green style for info
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;

  /// If null, only the confirm button is shown
  final String? cancelText;
  final bool isDanger;
  final IconData icon;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.isDanger,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // 1) Colors change with the dialog type
    Color mainColor;
    Color iconBackground;
    Color buttonTextColor;
    if (isDanger) {
      mainColor = AppColors.danger;
      iconBackground = AppColors.dangerLight;
      buttonTextColor = AppColors.white;
    } else {
      mainColor = AppColors.primary;
      iconBackground = AppColors.lightMint;
      buttonTextColor = AppColors.darkGreen;
    }

    // 2) The buttons at the bottom
    final buttons = <Widget>[];

    if (cancelText != null) {
      buttons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkGreen,
              backgroundColor: AppColors.white,
              minimumSize: const Size(0, 52),
              side:  BorderSide(color: AppColors.mintBorder, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              cancelText!,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      buttons.add(const SizedBox(width: 12));
    }

    buttons.add(
      Expanded(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: buttonTextColor,
            minimumSize: const Size(0, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            confirmText,
            style: AppTextStyles.bodyLarge.copyWith(
              color: buttonTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    // 3) The dialog box: icon, title, message, buttons
    //
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side:  BorderSide(color: AppColors.mintBorder, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: iconBackground,
              child: Icon(icon, color: mainColor, size: 34),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(children: buttons),
          ],
        ),
      ),
    );
  }
}
