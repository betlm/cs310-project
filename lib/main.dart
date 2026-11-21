import 'package:flutter/material.dart';
import 'data/app_state.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PetPocketApp());
}

/// Root widget: applies the shared themes and the named routes
class PetPocketApp extends StatefulWidget {
  const PetPocketApp({super.key});

  @override
  State<PetPocketApp> createState() => _PetPocketAppState();
}

class _PetPocketAppState extends State<PetPocketApp> {
  @override
  void initState() {
    super.initState();
    // Screens call refreshApp() after changing appAppearance
    refreshApp = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetPocket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode() ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: Duration.zero,
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.routes,
    );
  }
}