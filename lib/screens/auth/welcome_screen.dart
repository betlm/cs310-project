import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../l10n/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final isCompact = screenHeight < 750;

          return SingleChildScrollView(
            child: CustomPaint(
              painter: _WelcomeBackgroundPainter(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          children: [
                            // Top spacing
                            SizedBox(
                              height: isCompact ? AppSpacing.md : AppSpacing.lg,
                            ),

                            // Pet illustration and decorative rings
                            SizedBox(
                              height: isCompact ? 240 : 260,
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Transform.rotate(
                                    angle: -0.4,
                                    child: Container(
                                      width: 255,
                                      height: 205,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.55,
                                          ),
                                          width: 1.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          150,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: 0.5,
                                    child: Container(
                                      width: 235,
                                      height: 245,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.45,
                                          ),
                                          width: 1.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          150,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: isCompact ? 174 : 188,
                                    height: isCompact ? 174 : 188,
                                    padding: const EdgeInsets.all(
                                      AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(42),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(34),
                                      child: Image.asset(
                                        'assets/images/welcome-pets.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.sm),

                            // PetPocket branding
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: isCompact
                                  ? AppSpacing.xl
                                  : AppSpacing.xxl,
                            ),

                            // Main headline
                            Text(
                              AppStrings.get('welcomeHeadline'),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headingLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.md),

                            // Supporting description
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 310),
                              child: Text(
                                AppStrings.get('welcomeSubtitle'),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: isCompact ? AppSpacing.lg : AppSpacing.xl,
                            ),

                            // Shared primary button
                            PrimaryButton(
                              text: AppStrings.get('signIn'),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.signIn);
                              },
                            ),

                            const SizedBox(height: 12),

                            // Create account button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.signUp,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.darkGreen,
                                  backgroundColor: AppColors.background,
                                  side: BorderSide(
                                    color: AppColors.mintBorder,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMedium,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.get('createAccount'),
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mintPaint = Paint()..color = AppColors.lightMint;

    final creamPaint = Paint()..color = AppColors.background;

    canvas.drawRect(Offset.zero & size, mintPaint);

    final path = Path()
      ..moveTo(size.width, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height * 0.65)
      ..close();

    canvas.drawPath(path, creamPaint);
  }

  @override
  bool shouldRepaint(covariant _WelcomeBackgroundPainter oldDelegate) {
    return false;
  }
}
