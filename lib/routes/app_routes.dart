import 'package:flutter/material.dart';

import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/health/health_record_form_screen.dart';
import '../screens/health/weight_tracking_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/pets/pet_form_screen.dart';
import '../screens/photos/photos_screen.dart';
import '../screens/reminders/reminder_form_screen.dart';
import '../screens/reminders/reminders_screen.dart';
import '../screens/supplies/supply_form_screen.dart';
import '../screens/supplies/supply_list_screen.dart';
import '../screens/health/health_history_screen.dart';

/// Names (addresses) of all screens that can be opened with Navigator.
///
/// Home, My pets and Preferences are tabs inside the main shell. Health history is a tab too and it also has a route so Home can open it as a separate page

class AppRoutes {
  AppRoutes._();

  // Account
  static const String welcome = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';

  // Main app with the bottom navigation bar
  static const String shell = '/main';

  // Pets
  static const String petForm = '/pets/form';

  // Reminders
  static const String reminders = '/reminders';
  static const String reminderForm = '/reminders/form';

  // Health
  static const String healthRecordForm = '/health/form';
  static const String weightTracking = '/health/weight';
  static const String healthHistory = '/health';

  // Supplies
  static const String supplies = '/supplies';
  static const String supplyForm = '/supplies/form';

  // Photos
  static const String photos = '/photos';

  /// Which screen each route name opens.
  static Map<String, WidgetBuilder> get routes => {
    welcome: (_) => const WelcomeScreen(),
    signIn: (_) => const SignInScreen(),
    signUp: (_) => const SignUpScreen(),
    shell: (_) => const MainShell(),
    petForm: (_) => const PetFormScreen(),
    reminders: (_) => const RemindersScreen(),
    reminderForm: (_) => const ReminderFormScreen(),
    healthHistory: (_) => const HealthHistoryScreen(),
    healthRecordForm: (_) => const HealthRecordFormScreen(),
    weightTracking: (_) => const WeightTrackingScreen(),
    supplies: (_) => const SupplyListScreen(),
    supplyForm: (_) => const SupplyFormScreen(),
    photos: (_) => const PhotosScreen(),
  };
}
