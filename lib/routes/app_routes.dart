/// Names (addresses) of all screens that can be opened with Navigator.
///
/// Home, Health history, My pets and Preferences are tabs inside the
/// main shell, so they do not have their own route names.

import 'package:flutter/material.dart';

import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/health/health_record_form_screen.dart';
import '../screens/health/weight_tracking_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/pets/pet_details_screen.dart';
import '../screens/pets/pet_form_screen.dart';
import '../screens/photos/photo_detail_screen.dart';
import '../screens/photos/photos_screen.dart';
import '../screens/reminders/reminder_form_screen.dart';
import '../screens/reminders/reminders_screen.dart';
import '../screens/supplies/supply_form_screen.dart';
import '../screens/supplies/supply_list_screen.dart';

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
  static const String petDetails = '/pets/details';

  // Reminders
  static const String reminders = '/reminders';
  static const String reminderForm = '/reminders/form';

  // Health
  static const String healthRecordForm = '/health/form';
  static const String weightTracking = '/health/weight';

  // Supplies
  static const String supplies = '/supplies';
  static const String supplyForm = '/supplies/form';

  // Photos
  static const String photos = '/photos';
  static const String photoDetail = '/photos/detail';


  /// Which screen each route name opens.
  static Map<String, WidgetBuilder> get routes => {
        welcome: (_) => const WelcomeScreen(),
        signIn: (_) => const SignInScreen(),
        signUp: (_) => const SignUpScreen(),
        shell: (_) => const MainShell(),
        petForm: (_) => const PetFormScreen(),
        petDetails: (_) => const PetDetailsScreen(),
        reminders: (_) => const RemindersScreen(),
        reminderForm: (_) => const ReminderFormScreen(),
        healthRecordForm: (_) => const HealthRecordFormScreen(),
        weightTracking: (_) => const WeightTrackingScreen(),
        supplies: (_) => const SupplyListScreen(),
        supplyForm: (_) => const SupplyFormScreen(),
        photos: (_) => const PhotosScreen(),
        photoDetail: (_) => const PhotoDetailScreen(),
      };

}