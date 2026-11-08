import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';
//test
/// Bottom navigation tab: health.
/// Shown inside MainShell, so it has no back arrow.
class HealthHistoryScreen extends StatelessWidget {
  const HealthHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health history')),
      body: const ScreenPlaceholder(
        title: 'Health history',
        links: {
          'Add record': AppRoutes.healthRecordForm,
          'Weight tracking': AppRoutes.weightTracking,
        },
      ),
    );
  }
}