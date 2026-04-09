import 'package:intl/intl.dart';

DateTime parseCustomDate(String dateString) {
  String formatted = dateString.replaceFirst(' ', 'T');

  if (!formatted.contains(RegExp(r':\d{2}$'))) {
    formatted += ':00';
  }

  return DateTime.parse(formatted);
}

String formatDate(String date) {
  return DateFormat('d MMM в H:mm').format(parseCustomDate(date));
}

String formatCreatedDate(String date) {
  try {
    final parsedDate = parseCustomDate(date);
    final now = DateTime.now();
    // final difference = now.difference(parsedDate);

    if (parsedDate.day == now.day &&
        parsedDate.month == now.month &&
        parsedDate.year == now.year) {
      return 'в ${DateFormat('H:mm').format(parsedDate)}';
    }

    final yesterday = now.subtract(Duration(days: 1));
    if (parsedDate.day == yesterday.day &&
        parsedDate.month == yesterday.month &&
        parsedDate.year == yesterday.year) {
      return 'вчера в ${DateFormat('H:mm').format(parsedDate)}';
    }

    if (parsedDate.year == now.year) {
      return DateFormat('d MMM в H:mm').format(parsedDate);
    }

    return DateFormat('d MMM yyyy в H:mm').format(parsedDate);
  } catch (e) {
    return date;
  }
}
