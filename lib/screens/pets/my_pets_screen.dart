import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';

//test
/// Bottom navigation tab: Pets.
/// Shown inside MainShell, so it has no back arrow.
class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My pets')),
      body: const ScreenPlaceholder(
        title: 'My pets',
        links: {
          'Add pet': AppRoutes.petForm,
          'Pet details': AppRoutes.petDetails,
        },
      ),
    );
  }
}