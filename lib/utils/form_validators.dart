import '../l10n/app_strings.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';

  if (email.isEmpty) {
    return AppStrings.get('enterYourEmail');
  }

  if (!_emailPattern.hasMatch(email)) {
    return AppStrings.get('validEmail');
  }

  return null;
}