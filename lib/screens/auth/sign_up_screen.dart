import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/form_field_decoration.dart';
import '../../widgets/primary_button.dart';
import '../../utils/form_validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;

    // UI-only: Real authentication will be added later.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.shell,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),

                    // PetPocket branding
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 44,
                          height: 44,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'PetPocket',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // Heading
                    Text(
                      AppStrings.get('joinPetPocket'),
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      AppStrings.get('signUpSubtitle'),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Full name
                    fieldLabel(AppStrings.get('fullName')),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      style: AppTextStyles.bodyLarge,
                      decoration: fieldDecoration(
                        hint: AppStrings.get('enterYourNameHint'),
                        icon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.get('enterYourName');
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Email
                    fieldLabel(AppStrings.get('email')),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: AppTextStyles.bodyLarge,
                      decoration: fieldDecoration(
                        hint: AppStrings.get('emailExample'),
                        icon: Icons.mail_outline,
                      ),
                      validator: validateEmail,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Password
                    fieldLabel(AppStrings.get('password')),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      style: AppTextStyles.bodyLarge,
                      decoration:
                          fieldDecoration(
                            hint: AppStrings.get('atLeast8'),
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.secondaryText,
                              ),
                              tooltip: _obscurePassword
                                ? AppStrings.get('showPassword')
                                : AppStrings.get('hidePassword'),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.get('enterNewPassword');
                        }

                        if (value.length < 8) {
                          return AppStrings.get('passwordMin8');
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Confirm password
                    fieldLabel(AppStrings.get('confirmPassword')),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      style: AppTextStyles.bodyLarge,
                      decoration:
                          fieldDecoration(
                            hint: AppStrings.get('confirmPasswordHint'),
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.secondaryText,
                              ),
                              tooltip: _obscureConfirmPassword
                                ? AppStrings.get('showPassword')
                                : AppStrings.get('hidePassword'),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.get('confirmYourPassword');
                        }

                        if (value != _passwordController.text) {
                          return AppStrings.get('passwordsDontMatch');
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) => _createAccount(),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Shared primary button
                    PrimaryButton(
                      text: AppStrings.get('createAccount'),
                      onPressed: _createAccount,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '${AppStrings.get('haveAccount')} ',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.signIn,
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          child: Text(
                            AppStrings.get('signIn'),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
