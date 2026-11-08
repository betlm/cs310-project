import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';
//test
/// Bottom navigation tab: Home.
/// Shown inside MainShell, so it has no back arrow.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const ScreenPlaceholder(
        title: 'Home',
        links: {
          'Reminders': AppRoutes.reminders,
          'Supply list': AppRoutes.supplies,
          'Photos': AppRoutes.photos,
        },
      ),
    );
  }
}