import 'package:flutter/material.dart';

import '../../widgets/screen_placeholder.dart';

//test

class PetFormScreen extends StatelessWidget {
  const PetFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create / edit pet')),
      body: const ScreenPlaceholder(title: 'Create / edit pet'),
    );
  }
}