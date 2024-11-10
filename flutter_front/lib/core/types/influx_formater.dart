import 'package:intl/intl.dart';

String formatDateTimeForInflux(DateTime dateTime, {String format = 'local'}) {
  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  final localOffset = DateTime.now().timeZoneOffset;

  switch (format) {
    case 'Z':
      return '${formatter.format(dateTime)}Z';
    case 'RFC':
      return '${formatter.format(dateTime)}${dateTime.timeZoneOffset.isNegative ? '-' : '+'}${dateTime.timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}:${(dateTime.timeZoneOffset.inMinutes % 60).toString().padLeft(2, '0')}';
    case 'local':
      return '${formatter.format(dateTime)}${localOffset.isNegative ? '-' : '+'}${localOffset.inHours.abs().toString().padLeft(2, '0')}:${(localOffset.inMinutes % 60).toString().padLeft(2, '0')}';
    default:
      return '${formatter.format(dateTime)}Z';
  }
}