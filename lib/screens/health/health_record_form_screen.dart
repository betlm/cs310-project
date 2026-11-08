import 'package:flutter/material.dart';

import '../../widgets/screen_placeholder.dart';
//test
class HealthRecordFormScreen extends StatelessWidget {
  const HealthRecordFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create / edit record')),
      body: const ScreenPlaceholder(title: 'Create / edit record'),
    );
  }
}