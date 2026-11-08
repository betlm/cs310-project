import 'package:flutter/material.dart';

import '../health/health_history_screen.dart';
import '../pets/my_pets_screen.dart';
import '../settings/preferences_screen.dart';
import 'home_screen.dart';

/// The main app layout after sign-in, with the bottom navigation bar.
///
/// Each tab keeps its state while switching (IndexedStack).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// Lets screens inside the shell switch tabs,
  /// e.g. the Health card on Home can call MainShell.switchTab(context, 1).
  static void switchTab(BuildContext context, int index) {
    context.findAncestorStateOfType<_MainShellState>()?._selectTab(index);
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // 0 = Home, 1 = Health, 2 = Pets, 3 = Profile
  int _currentIndex = 0;

  static const List<Widget> _tabs = [
    HomeScreen(),
    HealthHistoryScreen(),
    MyPetsScreen(),
    PreferencesScreen(),
  ];

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Health',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}