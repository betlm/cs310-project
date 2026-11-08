/// Names (addresses) of all screens that can be opened with Navigator.
///
/// Home, Health history, My pets and Preferences are tabs inside the
/// main shell, so they do not have their own route names.
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
}