import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/screen_placeholder.dart';
//test

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Column(
        children: [
          const Expanded(child: ScreenPlaceholder(title: 'Sign up')),
          Padding(
            padding: AppSpacing.screenPadding,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.shell,
                (route) => false,
              ),
              child: const Text('Create account'),
            ),
          ),
        ],
      ),
    );
  }
}