import 'package:flutter/material.dart';

import '../../widgets/screen_placeholder.dart';
//test 

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo detail')),
      body: const ScreenPlaceholder(title: 'Photo detail'),
    );
  }
}