import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/form_field_decoration.dart';
import '../../l10n/app_strings.dart';

/// "User Information" sheet from the bottom,
/// change their name, e-mail and password
///
/// Use it with await and refresh the screen afterwards
///   await showUserInfoSheet(context);
///   if (!mounted) return;
///   setState(() {});
Future<void> showUserInfoSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => const _UserInfoSheet(),
  );
}

class _UserInfoSheet extends StatefulWidget {
  const _UserInfoSheet();

  @override
  State<_UserInfoSheet> createState() => _UserInfoSheetState();
}

class _UserInfoSheetState extends State<_UserInfoSheet> {
  final _formKey = GlobalKey<FormState>();

  // Name and e-mail start with the current values
  final _nameController = TextEditingController(text: userName);
  final _emailController = TextEditingController(text: userEmail);

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// True if the user typed anything into one of the password fields
  /// Then all three password fields are checked; otherwise they are skipped
  bool get _changingPassword {
    return _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;
  }

  // Validators: return an error message, or null if the value is OK
  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return AppStrings.get('enterYourName');
    }
    if (name.length > 40) {
      return AppStrings.get('nameTooLong');
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return AppStrings.get('enterYourEmail');
    }
    // Same rule as the Sign in and Sign up screens.
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return AppStrings.get('validEmail');
    }
    return null;
  }

  String? _validateCurrentPassword(String? value) {
    if (!_changingPassword) return null;
    if (value == null || value.isEmpty) {
      return AppStrings.get('enterCurrentPassword');
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (!_changingPassword) return null;
    if (value == null || value.length < 8) {
      return AppStrings.get('atLeast8');
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_changingPassword) return null;
    if (value != _newPasswordController.text) {
      return AppStrings.get('passwordsDontMatch');
    }
    return null;
  }

  /// Checks for saves the name and e-mail, closes the sheet and shows a short message
  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final passwordChanged = _changingPassword;

    userName = _nameController.text.trim();
    userEmail = _emailController.text.trim();
    // The password is not stored yet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          passwordChanged
              ? AppStrings.get('profilePasswordUpdated')
              : AppStrings.get('profileUpdated'),
        ),
      ),
    );

    Navigator.pop(context);
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return fieldDecoration(hint: hint, icon: icon).copyWith(
      hintStyle:  TextStyle(fontSize: 14, color: AppColors.hint),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      errorMaxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Height of the keyboard (0 when it is closed)
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final fieldText = TextStyle(fontSize: 14, color: AppColors.darkGreen);

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and close button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.get('accountSection').toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            AppStrings.get('userInformation'),
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.lightMint,
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Name and e-mail
                _label(AppStrings.get('fullName')),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: fieldText,
                  validator: _validateName,
                  decoration: _inputDecoration(
                    AppStrings.get('yourName'),
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 14),
                _label(AppStrings.get('email')),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: fieldText,
                  validator: _validateEmail,
                  decoration: _inputDecoration(
                    AppStrings.get('emailHint'),
                    icon: Icons.mail_outline,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                 Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: AppSpacing.md),

                // Change password
                 Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: AppColors.darkGreen,
                    ),
                    SizedBox(width: 8),
                    Text(
                      AppStrings.get('changePassword'),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                 Text(
                  AppStrings.get('keepPasswordNote'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 14),
                _label(AppStrings.get('currentPassword')),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  style: fieldText,
                  validator: _validateCurrentPassword,
                  decoration: _inputDecoration(
                    AppStrings.get('currentPasswordHint'),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label(AppStrings.get('newPassword')),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: true,
                            style: fieldText,
                            validator: _validateNewPassword,
                              decoration: _inputDecoration(
                                AppStrings.get('atLeast8'),
                              ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label(AppStrings.get('confirmPassword')),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            style: fieldText,
                            validator: _validateConfirmPassword,
                            decoration: _inputDecoration(
                              AppStrings.get('repeatPassword'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkGreen,
                          backgroundColor: AppColors.white,
                          minimumSize: const Size(0, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          side:  BorderSide(
                            color: AppColors.cardBorder,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: Text(AppStrings.get('cancel')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.darkGreen,
                          elevation: 0,
                          minimumSize: const Size(0, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: Text(AppStrings.get('saveChangesTitle')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}