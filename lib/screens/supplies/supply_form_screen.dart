import 'package:flutter/material.dart';

import '../../widgets/screen_placeholder.dart';

//test
class SupplyFormScreen extends StatelessWidget {
  const SupplyFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add / edit supply')),
      body: const ScreenPlaceholder(title: 'Add / edit supply'),
    );
  }
}