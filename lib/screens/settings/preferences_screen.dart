import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/screen_placeholder.dart';

//test
/// Bottom navigation tab: Profile.
/// Shown inside MainShell, so it has no back arrow.
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Column(
        children: [
          const Expanded(child: ScreenPlaceholder(title: 'Preferences')),
          Padding(
            padding: AppSpacing.screenPadding,
            child: OutlinedButton(
              // Sign out: go back to Welcome and clear the navigation history.
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.welcome,
                (route) => false,
              ),
              child: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }
}