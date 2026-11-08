import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';

//test screen

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: const ScreenPlaceholder(
        title: 'Reminders',
        links: {'Add reminder': AppRoutes.reminderForm},
      ),
    );
  }
}