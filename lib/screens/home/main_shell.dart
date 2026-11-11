import 'package:flutter/material.dart';

import '../health/health_history_screen.dart';
import '../pets/my_pets_screen.dart';
import '../settings/preferences_screen.dart';
import 'home_screen.dart';
import '../../theme/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      // Thin line above the bar, as in the Figma design.
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.navBorder)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor:
                isDark ? AppColors.navBackgroundDark : AppColors.white,
            // No pill behind the selected tab.
            indicatorColor: Colors.transparent,
            // Removes the Material 3 color tint, so white stays white.
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            height: 64,
            // Selected tab: green; others: grey.
            iconTheme: WidgetStateProperty.resolveWith(
              (states) => IconThemeData(
                size: 24,
                color: states.contains(WidgetState.selected)
                    ? AppColors.primary
                    : AppColors.navInactive,
              ),
            ),
            labelTextStyle: WidgetStateProperty.resolveWith(
              (states) => TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 11,
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w800
                    : FontWeight.w500,
                color: states.contains(WidgetState.selected)
                    ? AppColors.primary
                    : AppColors.navInactive,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _selectTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border),
                label: 'Health',
              ),
              NavigationDestination(
                icon: Icon(Icons.pets),
                label: 'Pets',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}