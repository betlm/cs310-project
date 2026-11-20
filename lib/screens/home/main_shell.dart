import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../health/health_history_screen.dart';
import '../pets/my_pets_screen.dart';
import '../settings/preferences_screen.dart';
import 'home_screen.dart';
import '../../data/app_state.dart';

/// The main app layout after sign-in, with the bottom navigation bar.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // 0 = Home, 1 = Health, 2 = Pets, 3 = Profile
  int _currentIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  void _onAppearanceChanged() {
  setState(() {});
  if (refreshApp != null) {
    refreshApp!();
  }
}

  @override
  Widget build(BuildContext context) {
    // The tabs are created again on every build, so each tab
    // always shows the current active pet.
    final tabs = [
      HomeScreen(
        onOpenHealth: () => _selectTab(1),
        onAppearanceChanged: _onAppearanceChanged,
      ),
      const HealthHistoryScreen(),
      const MyPetsScreen(),
      PreferencesScreen(onAppearanceChanged: _onAppearanceChanged),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      // Thin line above the bar, as in the Figma design.
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.navBorder)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _selectTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.navBackground,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.navInactive,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Health',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Pets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}