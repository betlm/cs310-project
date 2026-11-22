import '../data/app_state.dart';

/// Formats dates according to the selected language.
String formatDate(DateTime date) {
  if (appLanguage == 'tr') {
    return '${_twoDigits(date.day)}.${_twoDigits(date.month)}.${date.year}';
  }

  return '${_twoDigits(date.month)}/${_twoDigits(date.day)}/${date.year}';
}

/// Formats time as HH:MM.
String formatTime(int hour, int minute) {
  return '${_twoDigits(hour)}:${_twoDigits(minute)}';
}

/// Adds a leading zero to single-digit numbers.
String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
