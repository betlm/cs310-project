import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/screen_placeholder.dart';
//test

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Column(
        children: [
          const Expanded(child: ScreenPlaceholder(title: 'Sign in')),
          Padding(
            padding: AppSpacing.screenPadding,
            child: ElevatedButton(
              // UI only in Step 2.2: go straight to the app and remove the
              // welcome/sign-in screens so Back does not return to them
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.shell,
                (route) => false,
              ),
              child: const Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }
}