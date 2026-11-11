
String formatDate(DateTime date) =>
    '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
/// Shared date and time formatting so every screen shows them the same way.

/// Formats a date as DD/MM/YYYY, e.g. 10/11/2026.

/// Formats a time as 24-hour HH:MM, e.g. 09:00.
String formatTime(int hour, int minute) =>
    '${_twoDigits(hour)}:${_twoDigits(minute)}';

/// Adds a leading zero to single-digit numbers: 9 -> "09".
String _twoDigits(int n) => n.toString().padLeft(2, '0');