import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_spacing.dart';
//test

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'PetPocket',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.signIn),
              child: const Text('Sign in'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}