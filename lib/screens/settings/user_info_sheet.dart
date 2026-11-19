import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/form_field_decoration.dart';

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

  /// Saves the changes Filled in in the next commit
  void _save() {}
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return fieldDecoration(hint: hint, icon: icon).copyWith(
      hintStyle: const TextStyle(fontSize: 14, color: AppColors.hint),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Height of the keyboard (0 when it is closed)
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    const fieldText = TextStyle(fontSize: 14, color: AppColors.darkGreen);

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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACCOUNT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'User Information',
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
                      child: const CircleAvatar(
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
                _label('Full Name'),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: fieldText,
                  decoration: _inputDecoration(
                    'Your name',
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 14),
                _label('Email'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: fieldText,
                  decoration: _inputDecoration(
                    'you@example.com',
                    icon: Icons.mail_outline,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: AppSpacing.md),

                // Change password
                const Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: AppColors.darkGreen,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Change Password',
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
                const Text(
                  'Leave blank to keep the current password.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 14),
                _label('Current Password'),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  style: fieldText,
                  decoration: _inputDecoration('Enter current password'),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('New Password'),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: true,
                            style: fieldText,
                            decoration:
                                _inputDecoration('At least 8 characters'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Confirm Password'),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            style: fieldText,
                            decoration: _inputDecoration('Repeat password'),
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
                          side: const BorderSide(
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
                        child: const Text('Cancel'),
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
                        child: const Text('Save Changes'),
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