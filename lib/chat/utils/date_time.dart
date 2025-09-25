/* External Widget */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

DateTime transformerAnyToDateTime(dynamic any) {
  if (any is Timestamp) {
    return DateTime.parse(any.toDate().toString());
  }
  if (any is DateTime) {
    return any;
  }
  if (any == null) {
    return DateTime.now();
  }
  final startIndex = any.indexOf('seconds=');
  final endIndex = any.indexOf(',', startIndex + 'seconds='.length);

  int seconds =
      int.parse(any.substring(startIndex + 'seconds='.length, endIndex));
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}

String transformTime(Timestamp time) {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  DateFormat timeFormat = DateFormat("HH:mm");
  final DateTime now = DateTime.now();
  final diff =
      (now.difference(DateTime.parse(time.toDate().toString())).inHours / 24)
          .round();

  if (diff == 0) {
    return timeFormat.format(DateTime.parse(time.toDate().toString()));
  }
  if (diff == 1) {
    return "Hier";
  }
  if (diff == 2) {
    return "Avant-hier";
  }
  if (diff > 2) {
    return dateFormat.format(DateTime.parse(time.toDate().toString()));
  }
  return "";
}

String transformTime2(DateTime time) {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final DateTime now = DateTime.now();
  final diff = (now.difference(time).inDays);

  if (diff == 0) {
    return "Aujourd'hui";
  }
  if (diff == 1) {
    return "Hier";
  }
  if (diff == 2) {
    return "Avant-hier";
  }
  if (diff > 2) {
    return dateFormat.format(time);
  }
  return "";
}

String transformInsideChatTime(DateTime date) {
  DateTime time =
      DateTime.fromMicrosecondsSinceEpoch(date.millisecondsSinceEpoch * 1000);
  final String hour = time.hour.toString().padLeft(2, "0");
  final String minute = time.minute.toString().padLeft(2, "0");
  return "$hour:$minute";
}
