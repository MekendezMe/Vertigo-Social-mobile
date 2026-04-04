import 'package:intl/intl.dart';

DateTime parseCustomDate(String dateString) {
  String formatted = dateString.replaceFirst(' ', 'T');

  if (!formatted.contains(RegExp(r':\d{2}$'))) {
    formatted += ':00';
  }

  return DateTime.parse(formatted);
}

String formatDate(String date) {
  return DateFormat('d MMM в H:mm', 'ru').format(parseCustomDate(date));
}
