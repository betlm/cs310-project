import 'package:flutter/material.dart';

import '../../widgets/screen_placeholder.dart';
//test

class WeightTrackingScreen extends StatelessWidget {
  const WeightTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight tracking')),
      body: const ScreenPlaceholder(title: 'Weight tracking'),
    );
  }
}