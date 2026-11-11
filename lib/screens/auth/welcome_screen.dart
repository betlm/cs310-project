
import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ),
              child: Stack(
                children: [
                  // Mint background with diagonal cream section.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WelcomeBackgroundPainter(),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.08,
                          ),

                          // Pet illustration and mint circles.
                          SizedBox(
                            height: 290,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.rotate(
                                  angle: -0.4,
                                  child: Container(
                                    width: 280,
                                    height: 230,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.55),
                                        width: 1.5,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(150),
                                    ),
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 0.5,
                                  child: Container(
                                    width: 260,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.45),
                                        width: 1.5,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(150),
                                    ),
                                  ),
                                ),

                                // White image card.
                                Container(
                                  width: 220,
                                  height: 220,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius:
                                        BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(42),
                                    child: Image.asset(
                                      'assets/images/welcome-pets.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // PetPocket logo and app name.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'PetPocket',
                                style: AppTextStyles.headingLarge.copyWith(
                                  color: AppColors.darkGreen,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 38),

                          // Main heading.
                          Text(
                            'All care details,\nin one pocket.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingLarge.copyWith(
                              color: AppColors.darkGreen,
                              fontSize: 36,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Subtitle.
                          Text(
                            "Easily track your pet's health, reminders, and supplies.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.secondaryText,
                              fontSize: 17,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Sign in button.
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.signIn,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.darkGreen,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Sign in',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.darkGreen,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Create account button.
                          SizedBox(
                            width: double.infinity,
                            height: 56,
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
                                side: const BorderSide(
                                  color: AppColors.mintBorder,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Create account',
                                style: AppTextStyles.button.copyWith(
                                  color: AppColors.darkGreen,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
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
    final mintPaint = Paint()
      ..color = AppColors.lightMint;

    final creamPaint = Paint()
      ..color = AppColors.background;

    canvas.drawRect(
      Offset.zero & size,
      mintPaint,
    );

    final path = Path()
      ..moveTo(size.width, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height * 0.65)
      ..close();

    canvas.drawPath(path, creamPaint);
  }

  @override
  bool shouldRepaint(
    covariant _WelcomeBackgroundPainter oldDelegate,
  ) {
    return false;
  }
}
