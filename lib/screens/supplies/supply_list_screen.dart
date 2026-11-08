import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/screen_placeholder.dart';
//test

class SupplyListScreen extends StatelessWidget {
  const SupplyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supply list')),
      body: const ScreenPlaceholder(
        title: 'Supply list',
        links: {'Add supply': AppRoutes.supplyForm},
      ),
    );
  }
}