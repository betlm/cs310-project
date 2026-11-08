import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';

//test

class PetDetailsScreen extends StatelessWidget {
  const PetDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet details')),
      body: const ScreenPlaceholder(
        title: 'Pet details',
        links: {'Edit pet': AppRoutes.petForm},
      ),
    );
  }
}