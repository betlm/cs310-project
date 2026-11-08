import 'package:flutter/material.dart';

import '../../widgets/screen_placeholder.dart';

//test

class ReminderFormScreen extends StatelessWidget {
  const ReminderFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create / edit reminder')),
      body: const ScreenPlaceholder(title: 'Create / edit reminder'),
    );
  }
}