import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';
//test

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),
      body: const ScreenPlaceholder(
        title: 'Photos',
        links: {'Photo detail': AppRoutes.photoDetail},
      ),
    );
  }
}